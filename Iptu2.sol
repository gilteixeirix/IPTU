// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IPTUChain {

    /*//////////////////////////////////////////////////////////////
                                ERROS
    //////////////////////////////////////////////////////////////*/
    error NotOwner();
    error NotPrefeitura();
    error NotFound();
    error AlreadyExists();
    error InvalidParams();
    error NotActive();
    error ParcelAlreadyPaid();
    error InvalidParcel();
    error WrongAmount();

    /*//////////////////////////////////////////////////////////////
                            CONTROLE
    //////////////////////////////////////////////////////////////*/
    address public owner;
    address public prefeitura;

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier onlyPrefeitura() {
        if (msg.sender != prefeitura) revert NotPrefeitura();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                        REENTRANCY GUARD
    //////////////////////////////////////////////////////////////*/
    uint256 private _status = 1;

    modifier nonReentrant() {
        require(_status != 2, "REENTRANCY");
        _status = 2;
        _;
        _status = 1;
    }

    /*//////////////////////////////////////////////////////////////
                            ESTRUTURA
    //////////////////////////////////////////////////////////////*/
    struct Lancamento {
        // Identificação
        string inscricao;
        address contribuinte;
        uint256 ano;

        // Financeiro
        uint256 total;
        uint256 parcelas;
        uint256 valorParcela;

        uint256 pagas;
        uint256 valorPago;

        // Regras
        uint256 vencimento;
        bool ativo;

        // 🔐 Rastreabilidade jurídica
        string versaoSistema;
        string origem;
        bytes32 hashCalculo;

        // Controle de parcelas
        mapping(uint256 => bool) parcelaPaga;
    }

    mapping(bytes32 => Lancamento) private _lanc;

    // 💰 saldo acumulado (pull payment)
    uint256 public saldoPrefeitura;

    /*//////////////////////////////////////////////////////////////
                                EVENTOS
    //////////////////////////////////////////////////////////////*/
    event Lancado(
        bytes32 id,
        string inscricao,
        address contribuinte,
        uint256 ano,
        string versaoSistema,
        bytes32 hashCalculo
    );

    event ParcelaPaga(
        bytes32 id,
        uint256 parcela,
        address pagador,
        uint256 valor,
        uint256 timestamp
    );

    event PrefeituraSacou(uint256 valor);
    event PrefeituraAtualizada(address nova);

    /*//////////////////////////////////////////////////////////////
                              CONSTRUTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _prefeitura) {
        require(_prefeitura != address(0), "prefeitura zero");
        owner = msg.sender;
        prefeitura = _prefeitura;
    }

    /*//////////////////////////////////////////////////////////////
                         ADMIN
    //////////////////////////////////////////////////////////////*/
    function atualizarPrefeitura(address nova) external onlyOwner {
        require(nova != address(0), "zero");
        prefeitura = nova;
        emit PrefeituraAtualizada(nova);
    }

    /*//////////////////////////////////////////////////////////////
                         LANÇAMENTO
    //////////////////////////////////////////////////////////////*/
    function lancarIPTU(
        string calldata inscricao,
        address contribuinte,
        uint256 ano,
        uint256 total,
        uint256 parcelas,
        uint256 vencimento,
        string calldata versaoSistema,
        string calldata origem,
        bytes32 hashCalculo
    ) external onlyPrefeitura returns (bytes32 id) {

        if (
            bytes(inscricao).length == 0 ||
            contribuinte == address(0) ||
            total == 0 ||
            parcelas == 0
        ) revert InvalidParams();

        // 🔐 ID único e seguro
        id = keccak256(abi.encodePacked(inscricao, contribuinte, ano));

        if (_exists(id)) revert AlreadyExists();

        uint256 valorParcela = total / parcelas;
        if (valorParcela * parcelas != total) revert InvalidParams();

        Lancamento storage L = _lanc[id];

        L.inscricao = inscricao;
        L.contribuinte = contribuinte;
        L.ano = ano;
        L.total = total;
        L.parcelas = parcelas;
        L.valorParcela = valorParcela;
        L.vencimento = vencimento;
        L.ativo = true;

        // 🔐 rastreabilidade
        L.versaoSistema = versaoSistema;
        L.origem = origem;
        L.hashCalculo = hashCalculo;

        emit Lancado(
            id,
            inscricao,
            contribuinte,
            ano,
            versaoSistema,
            hashCalculo
        );
    }

    /*//////////////////////////////////////////////////////////////
                        PAGAMENTO
    //////////////////////////////////////////////////////////////*/
    function pagarParcela(bytes32 id, uint256 parcela)
        external
        payable
        nonReentrant
    {
        Lancamento storage L = _requireLanc(id);

        if (!L.ativo) revert NotActive();
        if (parcela == 0 || parcela > L.parcelas) revert InvalidParcel();
        if (L.parcelaPaga[parcela]) revert ParcelAlreadyPaid();

        uint256 valorDevido = L.valorParcela;

        // 📅 multa simples após vencimento (10%)
        if (block.timestamp > L.vencimento) {
            valorDevido = (valorDevido * 110) / 100;
        }

        if (msg.value != valorDevido) revert WrongAmount();

        L.parcelaPaga[parcela] = true;
        L.pagas += 1;
        L.valorPago += msg.value;

        // 💰 acumula saldo (seguro)
        saldoPrefeitura += msg.value;

        emit ParcelaPaga(
            id,
            parcela,
            msg.sender,
            msg.value,
            block.timestamp
        );
    }

    /*//////////////////////////////////////////////////////////////
                    SAQUE (PREFEITURA)
    //////////////////////////////////////////////////////////////*/
    function sacar() external onlyPrefeitura nonReentrant {
        uint256 valor = saldoPrefeitura;
        saldoPrefeitura = 0;

        (bool ok, ) = payable(prefeitura).call{value: valor}("");
        require(ok, "falha");

        emit PrefeituraSacou(valor);
    }

    /*//////////////////////////////////////////////////////////////
                        CONSULTAS
    //////////////////////////////////////////////////////////////*/
    function getResumo(bytes32 id)
        external view
        returns (
            string memory inscricao,
            address contribuinte,
            uint256 ano,
            uint256 total,
            uint256 parcelas,
            uint256 valorParcela,
            uint256 pagas,
            uint256 valorPago,
            bool ativo,
            uint256 vencimento,
            string memory versaoSistema,
            string memory origem,
            bytes32 hashCalculo
        )
    {
        Lancamento storage L = _requireLanc(id);

        return (
            L.inscricao,
            L.contribuinte,
            L.ano,
            L.total,
            L.parcelas,
            L.valorParcela,
            L.pagas,
            L.valorPago,
            L.ativo,
            L.vencimento,
            L.versaoSistema,
            L.origem,
            L.hashCalculo
        );
    }

    function parcelaEstaPaga(bytes32 id, uint256 parcela)
        external view returns (bool)
    {
        Lancamento storage L = _requireLanc(id);
        if (parcela == 0 || parcela > L.parcelas) revert InvalidParcel();
        return L.parcelaPaga[parcela];
    }

    /*//////////////////////////////////////////////////////////////
                        HELPERS
    //////////////////////////////////////////////////////////////*/
    function _exists(bytes32 id) internal view returns (bool) {
        return _lanc[id].contribuinte != address(0);
    }

    function _requireLanc(bytes32 id)
        internal view
        returns (Lancamento storage)
    {
        Lancamento storage L = _lanc[id];
        if (L.contribuinte == address(0)) revert NotFound();
        return L;
    }

    /*//////////////////////////////////////////////////////////////
                    TRANSFERÊNCIA DE OWNER
    //////////////////////////////////////////////////////////////*/
    function transferOwnership(address novo) external onlyOwner {
        require(novo != address(0), "zero");
        owner = novo;
    }
}
