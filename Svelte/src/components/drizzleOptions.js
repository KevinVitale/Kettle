import Migrations from '../../truffle/build/contracts/Migrations.json';
import AdvancedStorage from '../../truffle/build/contracts/AdvancedStorage.json';

export default {
    web3: {
        block: false,
    },
    contracts: [
        Migrations,
        AdvancedStorage,
    ],
    polls: {
        accounts: 3000,
    },
    events: {}
};
