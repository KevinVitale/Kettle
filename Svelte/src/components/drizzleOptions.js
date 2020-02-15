// import Migrations from '../../truffle/build/contracts/Migrations.json';
// import AdvancedStorage from '../../truffle/build/contracts/AdvancedStorage.json';
import DepositContract from '../../truffle/build/contracts/validator_registration.json';

export default {
    web3: {
        block: false,
    },
    contracts: [
        // Migrations,
        // AdvancedStorage,
        DepositContract
    ],
    polls: {
        accounts: 3000,
    },
    events: {
        DepositContract: ["DepositEvent"]
    }
};
