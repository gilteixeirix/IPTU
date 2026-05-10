<!doctype html>
<html lang="pt-BR">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Lançamento de IPTU Chain V2</title>

  <script src="https://cdn.jsdelivr.net/npm/ethers@5.7.2/dist/ethers.umd.min.js"></script>

  <style>
    :root {
      --bg: #0f1724;
      --card: #071329;
      --accent: #7c3aed;
      --muted: #9fb0c8;
      color: #e6eef8
    }

    body {
      margin: 0;
      background: linear-gradient(180deg, #071022 0%, #071733 100%);
      font-family: Inter, Arial, sans-serif;
      color: var(--muted);
      padding: 20px
    }

    .wrap {
      max-width: 980px;
      margin: 12px auto
    }

    header {
      display: flex;
      justify-content: space-between;
      align-items: center
    }

    h1 {
      color: #fff;
      margin: 0;
      font-size: clamp(1.2rem, 2vw, 1.8rem)
    }

    .card {
      background: rgba(255, 255, 255, 0.03);
      border-radius: 12px;
      padding: 16px;
      margin: 12px 0;
      box-shadow: 0 6px 18px rgba(2, 6, 23, 0.6)
    }

    label {
      display: block;
      font-size: 13px;
      color: var(--muted);
      margin-top: 8px
    }

    input[type=text],
    input[type=number],
    textarea,
    select {
      width: 100%;
      padding: 10px;
      border-radius: 8px;
      border: 1px solid rgba(255, 255, 255, 0.04);
      background: transparent;
      color: var(--muted);
      box-sizing: border-box
    }

    button {
      background: var(--accent);
      color: #fff;
      padding: 8px 12px;
      border: none;
      border-radius: 8px;
      cursor: pointer
    }

    .muted {
      color: var(--muted);
      font-size: 13px
    }

    .row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px
    }

    .result {
      white-space: pre-wrap;
      background: rgba(0, 0, 0, 0.18);
      padding: 10px;
      border-radius: 8px;
      color: #dcefff;
      margin-top: 8px
    }

    footer {
      margin-top: 12px;
      color: var(--muted);
      font-size: 13px;
      text-align: center
    }

    @media (max-width: 600px) {
      .row {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>

<body>

  <div class="wrap">

    <header>
      <h1>Lançamento de IPTU Chain V2</h1>
      <button id="connectBtn">Conectar MetaMask</button>
      <div class="muted">Conta: <span id="addr">—</span></div>
    </header>

    <div class="card">

      <div style="display:flex; align-items:center; gap:10px;">

        <label for="contractAddr">Endereço do contrato</label>

        <input id="contractAddr" type="text" placeholder="0x..."
          style="width:500px; height:28px; margin-top:20px;" />

      </div>

      <div style="margin-top:8px; display:flex; flex-wrap:wrap; gap:8px;">
        <button id="loadBtn">Carregar contrato</button>
        <button id="refreshMetaBtn">Atualizar dados</button>
      </div>

      <div class="result" id="status">Aguardando ação...</div>
    </div>

    <div class="card">

      <h3 style="color:#fff;margin-top:0">Consultar Lançamento</h3>

      <div class="row">

        <div>
          <label>Inscrição</label>
          <input id="inscricao" placeholder="ex: 12345-6" />
        </div>

        <div>
          <label>Ano</label>
          <input id="ano" placeholder="2025" />
        </div>

      </div>

      <label>Contribuinte</label>
      <input id="contribuinteId" placeholder="0x..." />

      <div style="display:flex; align-items:center; gap:10px;">

        <label>ID (bytes32)</label>

        <input id="idField" type="text" placeholder="0x..."
          style="width:500px; height:28px; margin-top:20px;" />

      </div>

      <div style="margin-top:8px; display:flex; flex-wrap:wrap; gap:8px;">
        <button id="makeIdBtn">Gerar ID</button>
        <button id="consultBtn">Consultar Resumo</button>
      </div>

      <div class="result" id="resumoArea">—</div>

    </div>

    <div class="card">

      <h3 style="color:#fff;margin-top:0">Pagar Parcela</h3>

      <label>ID do lançamento</label>
      <input id="payId" placeholder="0x..." />

      <div class="row">

        <div>
          <label>Nº da parcela</label>
          <input id="parcelaNum" placeholder="1" />
        </div>

        <div>
          <label>Valor Stablecoin</label>
          <input id="parcelaVal" placeholder="ex: 100.00" />
        </div>

      </div>

      <div style="margin-top:8px; display:flex; flex-wrap:wrap; gap:8px;">
        <button id="fillParcelValue">Buscar valor oficial</button>
        <button id="payBtn">Pagar Parcela</button>
      </div>

      <div class="result" id="payStatus">—</div>

    </div>

    <div class="card" id="adminCard" style="display:none">

      <h3 style="color:#fff;margin-top:0">Administração</h3>

      <details open>

        <summary style="cursor:pointer">Lançar IPTU</summary>

        <div style="margin-top:8px">

          <label>Inscrição</label>
          <input id="l_inscricao" />

          <label>Contribuinte</label>
          <input id="l_contribuinte" placeholder="0x..." />

          <div class="row">

            <div>
              <label>Ano</label>
              <input id="l_ano" />
            </div>

            <div>
              <label>Parcelas</label>
              <input id="l_parcelas" />
            </div>

          </div>

          <label>Total Stablecoin</label>
          <input id="l_total" />

          <label>Hash Documento Jurídico</label>
          <input id="docHash" placeholder="0x..." />

          <div style="margin-top:8px; display:flex; flex-wrap:wrap; gap:8px;">
            <button id="lancarBtn">Lançar IPTU</button>
          </div>

          <div class="result" id="lancarStatus">—</div>

        </div>

      </details>

    </div>

    <footer>
      IPTU Chain V2 — Auditoria blockchain para arrecadação municipal.
    </footer>

  </div>

  <script>

    const ABI = [
      "function owner() view returns(address)",
      "function gerarId(string,address,uint256) pure returns(bytes32)",
      "function getResumo(bytes32) view returns(string,address,uint256,uint256,uint256,uint256,uint256,uint256,bool,bytes32)",
      "function lancarIPTU(string,address,uint256,uint256,uint256,bytes32)",
      "function pagarParcela(bytes32,uint256)",
      "event ParcelaPaga(bytes32 indexed id,uint256 parcela,address indexed contribuinte,uint256 valor,uint256 timestamp,bytes32 comprovanteHash)"
    ];

    const ERC20_ABI = [
      "function approve(address spender,uint256 amount) returns(bool)"
    ];

    const TOKEN_ADDRESS = "0xSEU_TOKEN";

    let provider;
    let signer;
    let contract;
    let token;
    let connectedAddress;
    let contractAddress;

    function status(msg) {
      document.getElementById('status').textContent = msg;
    }

    document.getElementById('connectBtn').onclick = async () => {

      if (!window.ethereum) {
        alert('MetaMask não encontrado');
        return;
      }

      await window.ethereum.request({ method: 'eth_requestAccounts' });

      provider = new ethers.providers.Web3Provider(window.ethereum);
      signer = provider.getSigner();

      connectedAddress = await signer.getAddress();

      document.getElementById('addr').textContent = connectedAddress;

      const network = await provider.getNetwork();

      if (network.chainId !== 137) {
        alert('Conecte na Polygon');
        return;
      }

      token = new ethers.Contract(TOKEN_ADDRESS, ERC20_ABI, signer);

      status('Carteira conectada');

    };

    document.getElementById('loadBtn').onclick = async () => {

      contractAddress = document.getElementById('contractAddr').value.trim();

      if (!ethers.utils.isAddress(contractAddress)) {
        alert('Contrato inválido');
        return;
      }

      contract = new ethers.Contract(contractAddress, ABI, signer);

      status('Contrato carregado com sucesso');

      try {

        contract.on('ParcelaPaga', (
          id,
          parcela,
          contribuinte,
          valor,
          timestamp,
          comprovanteHash
        ) => {

          console.log('Evento auditável:', {
            id,
            parcela,
            contribuinte,
            valor: valor.toString(),
            timestamp,
            comprovanteHash
          });

        });

      } catch (e) {
        console.log(e);
      }

    };

    document.getElementById('makeIdBtn').onclick = async () => {

      const inscr = document.getElementById('inscricao').value.trim();
      const contribuinte = document.getElementById('contribuinteId').value.trim();
      const ano = Number(document.getElementById('ano').value);

      const id = ethers.utils.solidityKeccak256(
        ['string', 'address', 'uint256'],
        [inscr, contribuinte, ano]
      );

      document.getElementById('idField').value = id;
      document.getElementById('payId').value = id;

    };

    document.getElementById('consultBtn').onclick = async () => {

      try {

        const id = document.getElementById('idField').value.trim();

        const r = await contract.getResumo(id);

        let texto = '';

        texto += 'Inscrição: ' + r[0] + '
';
        texto += 'Contribuinte: ' + r[1] + '
';
        texto += 'Ano: ' + r[2] + '
';
        texto += 'Total: ' + ethers.utils.formatUnits(r[3], 6) + '
';
        texto += 'Parcelas: ' + r[4] + '
';
        texto += 'Valor Parcela: ' + ethers.utils.formatUnits(r[5], 6) + '
';
        texto += 'Pagas: ' + r[6] + '
';
        texto += 'Valor Pago: ' + ethers.utils.formatUnits(r[7], 6) + '
';
        texto += 'Ativo: ' + r[8] + '
';
        texto += 'Documento Hash: ' + r[9] + '
';

        document.getElementById('resumoArea').textContent = texto;

        document.getElementById('parcelaVal').value = ethers.utils.formatUnits(r[5], 6);

      } catch (e) {
        alert('Erro consulta');
      }

    };

    document.getElementById('fillParcelValue').onclick = async () => {

      const id = document.getElementById('payId').value.trim();

      const r = await contract.getResumo(id);

      document.getElementById('parcelaVal').value = ethers.utils.formatUnits(r[5], 6);

    };

    document.getElementById('payBtn').onclick = async () => {

      try {

        const id = document.getElementById('payId').value.trim();
        const parcela = Number(document.getElementById('parcelaNum').value);

        const r = await contract.getResumo(id);

        const valor = r[5];

        const approveTx = await token.approve(contractAddress, valor);

        await approveTx.wait();

        const tx = await contract.pagarParcela(id, parcela);

        document.getElementById('payStatus').textContent = 'Transação enviada: ' + tx.hash;

        const receipt = await tx.wait();

        const explorer = `https://polygonscan.com/tx/${tx.hash}`;

        let comprovante = '';

        comprovante += '✅ PAGAMENTO CONFIRMADO

';
        comprovante += 'TX HASH:
' + tx.hash + '

';
        comprovante += 'EXPLORER:
' + explorer + '

';
        comprovante += 'BLOCO:
' + receipt.blockNumber + '
';

        document.getElementById('payStatus').textContent = comprovante;

      } catch (e) {

        console.log(e);

        if (e.message.includes('Parcela ja paga')) {
          alert('Parcela já quitada');
          return;
        }

        alert('Erro no pagamento');

      }

    };

    document.getElementById('lancarBtn').onclick = async () => {

      try {

        const inscr = document.getElementById('l_inscricao').value.trim();
        const cont = document.getElementById('l_contribuinte').value.trim();
        const ano = Number(document.getElementById('l_ano').value);
        const parcelas = Number(document.getElementById('l_parcelas').value);
        const total = document.getElementById('l_total').value.trim();
        const docHash = document.getElementById('docHash').value.trim();

        const totalUnits = ethers.utils.parseUnits(total, 6);

        const tx = await contract.lancarIPTU(
          inscr,
          cont,
          ano,
          totalUnits,
          parcelas,
          docHash
        );

        document.getElementById('lancarStatus').textContent = 'Tx enviada: ' + tx.hash;

        await tx.wait();

        document.getElementById('lancarStatus').textContent += '
✅ Confirmada';

      } catch (e) {

        console.log(e);
        alert('Erro ao lançar IPTU');

      }

    };

  </script>

</body>

</html>
