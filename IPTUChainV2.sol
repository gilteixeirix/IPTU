// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract IPTUChainV2 is AccessControl, ReentrancyGuard, Pausable {

    bytes32 public constant PREFEITURA_ROLE = keccak256("PREFEITURA_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");

    IERC20 public token;

    struct Lancamento {
        string inscricao;
        address contribuinte;
        uint256 ano;

        uint256 total;
        uint256 parcelas;
        uint256 valorParcela;

        uint256 pagas;
        uint256 valorPago;

        bool ativo;

        bytes32 documentoHash;

        mapping(uint256 => bool) parcelaPaga;
    }

    mapping(bytes32 => Lancamento) private lancamentos;

    event IPTULancado(
        bytes32 indexed id,
        string inscricao,
        address indexed contribuinte,
        uint256 ano,
        uint256 total,
        uint256 parcelas,
        bytes32 documentoHash
    );

    event ParcelaPaga(
        bytes32 indexed id,
        uint256 parcela,
        address indexed contribuinte,
        uint256 valor,
        uint256 timestamp,
        bytes32 comprovanteHash
    );

    event LancamentoCancelado(bytes32 indexed id);
    event LancamentoReativado(bytes32 indexed id);

    constructor(address stablecoin) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PREFEITURA_ROLE, msg.sender);

        token = IERC20(stablecoin);
    }

    function gerarId(
        string memory inscricao,
        address contribuinte,
        uint256 ano
    ) public pure returns(bytes32) {
        return keccak256(
            abi.encodePacked(inscricao, contribuinte, ano)
        );
    }

    function lancarIPTU(
        string calldata inscricao,
        address contribuinte,
        uint256 ano,
        uint256 total,
        uint256 parcelas,
        bytes32 documentoHash
    ) external onlyRole(PREFEITURA_ROLE) {

        require(contribuinte != address(0), "Endereco invalido");
        require(total > 0, "Total invalido");
        require(parcelas > 0, "Parcelas invalidas");

        bytes32 id = gerarId(inscricao, contribuinte, ano);

        Lancamento storage L = lancamentos[id];

        require(L.contribuinte == address(0), "Ja existe");

        uint256 valorParcela = total / parcelas;

        require(valorParcela * parcelas == total, "Divisao invalida");

        L.inscricao = inscricao;
        L.contribuinte = contribuinte;
        L.ano = ano;
        L.total = total;
        L.parcelas = parcelas;
        L.valorParcela = valorParcela;
        L.ativo = true;
        L.documentoHash = documentoHash;

        emit IPTULancado(
            id,
            inscricao,
            contribuinte,
            ano,
            total,
            parcelas,
            documentoHash
        );
    }

    function pagarParcela(
        bytes32 id,
        uint256 parcela
    ) external nonReentrant whenNotPaused {

        Lancamento storage L = lancamentos[id];

        require(L.contribuinte != address(0), "Nao encontrado");
        require(L.ativo, "Inativo");
        require(msg.sender == L.contribuinte, "Nao autorizado");
        require(parcela > 0 && parcela <= L.parcelas, "Parcela invalida");
        require(!L.parcelaPaga[parcela], "Parcela ja paga");

        bool ok = token.transferFrom(
            msg.sender,
            address(this),
            L.valorParcela
        );

        require(ok, "Falha pagamento");

        L.parcelaPaga[parcela] = true;
        L.pagas += 1;
        L.valorPago += L.valorParcela;

        bytes32 comprovanteHash = keccak256(
            abi.encodePacked(
                block.timestamp,
                msg.sender,
                parcela,
                L.valorParcela
            )
        );

        emit ParcelaPaga(
            id,
            parcela,
            msg.sender,
            L.valorParcela,
            block.timestamp,
            comprovanteHash
        );
    }

    function cancelarLancamento(bytes32 id)
        external
        onlyRole(PREFEITURA_ROLE)
    {
        lancamentos[id].ativo = false;
        emit LancamentoCancelado(id);
    }

    function reativarLancamento(bytes32 id)
        external
        onlyRole(PREFEITURA_ROLE)
    {
        lancamentos[id].ativo = true;
        emit LancamentoReativado(id);
    }

    function sacarArrecadacao(address destino)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        uint256 saldo = token.balanceOf(address(this));
        token.transfer(destino, saldo);
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function getResumo(bytes32 id)
        external
        view
        returns(
            string memory,
            address,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            bool,
            bytes32
        )
    {
        Lancamento storage L = lancamentos[id];

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
            L.documentoHash
        );
    }
}
