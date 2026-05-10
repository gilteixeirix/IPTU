#![no_std]

use soroban_sdk::{
    contract, contractimpl, contracttype, Address, Env, Symbol, Vec, BytesN
};

#[contracttype]
#[derive(Clone)]
pub struct Lancamento {
    pub inscricao: Symbol,
    pub contribuinte: Address,
    pub ano: u32,

    pub total: i128,
    pub parcelas: u32,
    pub valor_parcela: i128,

    pub pagas: u32,
    pub valor_pago: i128,

    pub vencimento: u64,
    pub ativo: bool,

    // rastreabilidade
    pub versao: Symbol,
    pub origem: Symbol,
    pub hash_calculo: BytesN<32>,
}

#[contracttype]
pub enum DataKey {
    Owner,
    Prefeitura,
    Lancamento(BytesN<32>),
    Parcela(BytesN<32>, u32),
    SaldoPrefeitura,
}

#[contract]
pub struct IPTUContract;

#[contractimpl]
impl IPTUContract {

    // INIT
    pub fn init(env: Env, owner: Address, prefeitura: Address) {
        owner.require_auth();
        env.storage().instance().set(&DataKey::Owner, &owner);
        env.storage().instance().set(&DataKey::Prefeitura, &prefeitura);
        env.storage().instance().set(&DataKey::SaldoPrefeitura, &0i128);
    }

    // HELPER
    fn get_prefeitura(env: &Env) -> Address {
        env.storage().instance().get(&DataKey::Prefeitura).unwrap()
    }

    fn get_owner(env: &Env) -> Address {
        env.storage().instance().get(&DataKey::Owner).unwrap()
    }

    // GERAR ID
    pub fn make_id(env: Env, inscricao: Symbol, contribuinte: Address, ano: u32) -> BytesN<32> {
        env.crypto().sha256(&(
            inscricao, contribuinte, ano
        ).into_val(&env))
    }

    // LANÇAR IPTU
    pub fn lancar_iptu(
        env: Env,
        inscricao: Symbol,
        contribuinte: Address,
        ano: u32,
        total: i128,
        parcelas: u32,
        vencimento: u64,
        versao: Symbol,
        origem: Symbol,
        hash_calculo: BytesN<32>
    ) -> BytesN<32> {

        let prefeitura = Self::get_prefeitura(&env);
        prefeitura.require_auth();

        let id = Self::make_id(env.clone(), inscricao.clone(), contribuinte.clone(), ano);

        if env.storage().instance().has(&DataKey::Lancamento(id.clone())) {
            panic!("Already exists");
        }

        let valor_parcela = total / parcelas as i128;

        let lanc = Lancamento {
            inscricao,
            contribuinte,
            ano,
            total,
            parcelas,
            valor_parcela,
            pagas: 0,
            valor_pago: 0,
            vencimento,
            ativo: true,
            versao,
            origem,
            hash_calculo,
        };

        env.storage().instance().set(&DataKey::Lancamento(id.clone()), &lanc);

        id
    }

    // PAGAR PARCELA
    pub fn pagar_parcela(
        env: Env,
        id: BytesN<32>,
        parcela: u32,
        valor: i128,
        pagador: Address
    ) {

        pagador.require_auth();

        let mut lanc: Lancamento = env.storage()
            .instance()
            .get(&DataKey::Lancamento(id.clone()))
            .unwrap();

        if !lanc.ativo {
            panic!("Not active");
        }

        if parcela == 0 || parcela > lanc.parcelas {
            panic!("Invalid parcela");
        }

        let parcela_key = DataKey::Parcela(id.clone(), parcela);

        if env.storage().instance().has(&parcela_key) {
            panic!("Already paid");
        }

        let mut valor_devido = lanc.valor_parcela;

        if env.ledger().timestamp() > lanc.vencimento {
            valor_devido = valor_devido * 110 / 100;
        }

        if valor != valor_devido {
            panic!("Wrong amount");
        }

        // marca parcela
        env.storage().instance().set(&parcela_key, &true);

        lanc.pagas += 1;
        lanc.valor_pago += valor;

        env.storage().instance().set(&DataKey::Lancamento(id.clone()), &lanc);

        // acumula saldo
        let mut saldo: i128 = env.storage()
            .instance()
            .get(&DataKey::SaldoPrefeitura)
            .unwrap();

        saldo += valor;

        env.storage().instance().set(&DataKey::SaldoPrefeitura, &saldo);
    }

    // SAQUE
    pub fn sacar(env: Env) {
        let prefeitura = Self::get_prefeitura(&env);
        prefeitura.require_auth();

        let saldo: i128 = env.storage()
            .instance()
            .get(&DataKey::SaldoPrefeitura)
            .unwrap();

        // aqui você integraria com token contract

        env.storage().instance().set(&DataKey::SaldoPrefeitura, &0i128);
    }

    // CONSULTA
    pub fn get_resumo(env: Env, id: BytesN<32>) -> Lancamento {
        env.storage().instance().get(&DataKey::Lancamento(id)).unwrap()
    }
}
