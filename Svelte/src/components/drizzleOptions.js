// import Migrations from '../../truffle/build/contracts/Migrations.json';
// import AdvancedStorage from '../../truffle/build/contracts/AdvancedStorage.json';
// import DepositContract from '../../tornado-core/build/contracts/validator_registration.json';
import ETHTornado from '../../tornado-core/build/contracts/ETHTornado.json';

export default {
    web3: {
        block: false,
    },
    contracts: [
        // Migrations,
        // AdvancedStorage,
        // DepositContract,
        ETHTornado,
    ],
    polls: {
        accounts: 3000,
    },
    events: {
        // DepositContract: ["DepositEvent"]
    }
};
