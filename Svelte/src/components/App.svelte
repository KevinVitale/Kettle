<!-- 
	Reference: https://github.com/edgefund/edgefund-cointoss/blob/master/app/App.svelte
--> 
<script>
	import axios from "axios";
	import snarkjs from "snarkjs";
	import crypto from "crypto";
	import circomlib from "circomlib";
	import merkleTree from "../lib/MerkleTree";
	import websnarkUtils from "websnark/src/utils";
	import buildGroth16 from "websnark/src/groth16";
	import Web3 from "web3";
	import { onMount } from 'svelte';
	import { getDrizzleProvider, getWCProvider, getProvider } from '../walletConnect';
	import options from './drizzleOptions';
	import { Drizzle, generateStore } from 'drizzle';

	const bigInt = snarkjs.bigInt;

	let recentNote;
	let groth16, circuit, proving_key;
	let MERKLE_TREE_HEIGHT;

	/** Generate random number of specified byte length */
	const rbigint = nbytes => snarkjs.bigInt.leBuff2int(crypto.randomBytes(nbytes))

	/** Compute pedersen hash */
	const pedersenHash = data => circomlib.babyJub.unpackPoint(circomlib.pedersenHash.hash(data))[0]

	/** BigNumber to hex string of specified length */
	function toHex(number, length = 32) {
		let str = number instanceof Buffer ? number.toString('hex') : bigInt(number).toString(16)
		return '0x' + str.padStart(length * 2, '0')
	}

	/**
	 * Make an ETH deposit
	*/
	async function deposit() {
		const deposit = createDeposit(rbigint(31), rbigint(31))

		console.log('Submitting deposit transaction')

		let contract = drizzle.contracts["ETHTornado"];
		let senderAccount = accounts[0];
		await contract.methods.deposit(toHex(deposit.commitment)).send({ value: 32e18, from: senderAccount, gas: 2e6 })

		const note = toHex(deposit.preimage, 62)
		console.log('Your note:', note)
		return note
	}

	/**
	 * Create deposit object from secret and nullifier
	 */
	function createDeposit(nullifier, secret) {
		let deposit = { nullifier, secret }
		deposit.preimage = Buffer.concat([deposit.nullifier.leInt2Buff(31), deposit.secret.leInt2Buff(31)])
		deposit.commitment = pedersenHash(deposit.preimage)
		deposit.nullifierHash = pedersenHash(deposit.nullifier.leInt2Buff(31))
		return deposit
	}

	/** Display account balance */
	async function printBalance(account, name) {
		console.log(`${name} ETH balance is`, web3.utils.fromWei(await web3.eth.getBalance(account)))
		console.log(`${name} Token Balance is`, web3.utils.fromWei(await erc20.methods.balanceOf(account).call()))
	}

	let state = { };
	let drizzle = { };
	let provider = { };

	$: accounts = state.accounts ? state.accounts : []; 
	$: contracts = state.contracts ? state.contracts : [];

	async function handleClick(event) {
		provider.eth.sendTransaction({
			to: "0x0Cbe55DF6ec0b2AD41274Dad7Ccf17fc632CF749",
			from: "0x3e07d9AE4662CA5A541746Be369354DDAE09903C",
			gasPrice: 20000000,
			value: provider.utils.numberToHex((1 * 1e18)),
		})
		.on('transactionHash', function (hash) { console.log("Hash: " + hash); })
		.on('receipt', function (receipt) { console.log("Receipt: " + receipt); })
		.on('confirmation', function (confirmationNumber, receipt) { console.log("confirm: " + confirmationNumber, receipt); })
		.on('error', function (error) { console.log(JSON.stringify(error)); });
	};

	async function generateMerkleProof(contract, deposit) {
		// Get all deposit events from smart contract and assemble merkle tree from them
		console.log('Getting current state from tornado contract');
		const events = await contract.getPastEvents('Deposit', { fromBlock: 16793657, toBlock: 'latest' })
		const leaves = events
			.sort((a, b) => a.returnValues.leafIndex - b.returnValues.leafIndex) // Sort events in chronological order
			.map(e => e.returnValues.commitment);
		const tree = new merkleTree(MERKLE_TREE_HEIGHT, leaves)

		// Find current commitment in the tree
		let depositEvent = events.find(e => e.returnValues.commitment === toHex(deposit.commitment))
		let leafIndex = depositEvent ? depositEvent.returnValues.leafIndex : -1

		// Validate that our data is correct
		const isValidRoot = await contract.methods.isKnownRoot(toHex(await tree.root())).call()
		const isSpent = await contract.methods.isSpent(toHex(deposit.nullifierHash)).call()

		console.log(isValidRoot, isSpent);
		// assert(isValidRoot === true, 'Merkle tree is corrupted')
		// assert(isSpent === false, 'The note is already spent')
		// assert(leafIndex >= 0, 'The deposit is not found in the tree')

		// Compute merkle proof of our commitment
		return await tree.path(leafIndex)
	}

	async function generateProof(contract, note, recipient, relayer = 0, fee = 0, refund = 0) {
		// Decode hex string and restore the deposit object
		let buf = Buffer.from(note.slice(2), 'hex')
		let deposit = createDeposit(bigInt.leBuff2int(buf.slice(0, 31)), bigInt.leBuff2int(buf.slice(31, 62)))

		// Compute merkle proof of our commitment
		const { root, path_elements, path_index } = await generateMerkleProof(contract, deposit)
		console.log(root, path_elements, path_index);

		// Prepare circuit input
		const input = {
			// Public snark inputs
			root: root,
			nullifierHash: deposit.nullifierHash,
			recipient: bigInt(recipient),
			relayer: bigInt(relayer),
			fee: bigInt(fee),
			refund: bigInt(refund),

			// Private snark inputs
			nullifier: deposit.nullifier,
			secret: deposit.secret,
			pathElements: path_elements,
			pathIndices: path_index,
		}

		console.log('Generating SNARK proof');
		console.time('Proof time');
		const proofData = await websnarkUtils.genWitnessAndProve(groth16, input, circuit, proving_key)
		const { proof } = websnarkUtils.toSolidityInput(proofData)
		console.timeEnd('Proof time')

		const args = [
			toHex(input.root),
			toHex(input.nullifierHash),
			toHex(input.recipient, 20),
			toHex(input.relayer, 20),
			toHex(input.fee),
			toHex(input.refund)
		]

		return { proof, args }
	}

	async function tornadoCashDeposit(event) {
		recentNote = await deposit()
	}

	async function tornadoCashWithdrawl(event) {
		let contract = new provider.eth.Contract(drizzle.contractList[1]._jsonInterface, drizzle.contractList[1].address);
		let recipient = '0x0Cbe55DF6ec0b2AD41274Dad7Ccf17fc632CF749';

		recentNote = '0xcf3076006592fc3a7c0ce3c583ff2cb184a15934484318c7c06f2ebf6edbe82f2d420813731beab6fd9dae0133522645d6ab9db6240512562a9539b1ede8';
		const { proof, args } = await generateProof(contract, recentNote, recipient);

		console.log('Submitting withdraw transaction');
		await contract.methods.withdraw(proof, ...args).send({ from: recipient, gas: 1e6 });
		console.log('Done');
	}

	onMount(async () => {
		provider = await getDrizzleProvider();
		const drizzleStore = generateStore(options);
		drizzle = new Drizzle(options, drizzleStore);

		drizzleStore.subscribe(() => {
			state = drizzleStore.getState();
		});

		// MERKLE_TREE_HEIGHT = 16;

		// groth16 = await buildGroth16();
		// circuit = require('../build/circuits/withdraw.json');
		// proving_key = await (await fetch('../build/circuits/withdraw_proving_key.bin')).arrayBuffer()

		window.drizzle = drizzle;
		window.drizzleStore = drizzleStore;
		window.provider = provider;
	});

</script>

<main>
	<h1>kettle</h1>
	<button on:click={handleClick}>
		Sign Transaction
	</button>
	<br/>
	<button on:click={tornadoCashDeposit}>
		Tornado Cash - Deposit
	</button>
	<br/>
	<button on:click={tornadoCashWithdrawl}>
		Tornado Cash - Withdrawl
	</button>
	<hr/>
	<h2>
		<p>Contract List</p>
	</h2>
	<ul>
	{#each Object.values(contracts) as contract, i}
		<p>
			<li>{ JSON.stringify(contract, null, 2) }</li>
		</p>
	{:else}
		Loading...
	{/each}
	</ul>
	<hr/>
	<h2>
		<p>Account List</p>
	</h2>
	<ul>
	{#each Object.values(accounts) as account, i}
		<p>
			<li>{ account }</li>
		</p>
	{:else}
		Loading...
	{/each}
	</ul>
</main>

<style>
	main {
		text-align: center;
		padding: 1em;
		width: 500px;
		margin: 0 auto;
	}

	h1 {
		color: #ff3e00;
		text-transform: uppercase;
		font-size: 4em;
		font-weight: 100;
	}

	h2 {
		color: #003e00;
		font-size: 2em;
		font-weight: 300;
	}

	p {
		text-align: left;
	}

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
