import Web3 from "web3";
import WalletConnectProvider from "@walletconnect/web3-provider";

export const getDrizzleProvider = () => {
    if ((<any>window).ethereum) {
        return new Web3((<any>window).ethereum);
    } else if ((<any>window).web3) {
        return new Web3((<any>window).web3.currentProvider);
    }
    return {};
};

export const getWCProvider = async () => {
	//  Create WalletConnect Provider
	const provider = new WalletConnectProvider({
    infuraId: "c0956459567e4d378ba715f962847bff",
    // Uncomment to use Ganache, assuming these flags:
    //  --host 192.168.1.24
    //  --networkId 100;
		rpc: { 
      100: "http://192.168.1.27:8545", 
      bridge: "https://bridge.walletconnect.org",
      shareNonce: false
    }
    // rpc: { 100: "http://10.19.48.1:8545" }
	});

	// Subscribe to accounts change
	provider.on("accountsChanged", (accounts: string[]) => {
		console.log(accounts);
	});

	// Subscribe to chainId change
	provider.on("chainChanged", (chainId: number) => {
		console.log("Chain Id: " + chainId);
	});

	// Subscribe to networkId change
	provider.on("networkChanged", (networkId: number) => {
		console.log(networkId);
	});

	// Subscribe to session connection/open
	provider.on("open", () => {
		console.log("open");
	});

	// Subscribe to session disconnection/close
	provider.on("close", (code: number, reason: string) => {
		console.log(code, reason);
	});

	//  Enable session (triggers QR Code modal)
	await provider.enable();
	
	return new Web3(provider);
};
