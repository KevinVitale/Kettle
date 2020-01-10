<!-- 
	Reference: https://github.com/edgefund/edgefund-cointoss/blob/master/app/App.svelte
--> 
<script>
  import Web3 from "web3";
	import { onMount } from 'svelte';
	import { getDrizzleProvider, getWCProvider, getProvider } from '../walletConnect';
	import options from './drizzleOptions';
	import { Drizzle, generateStore } from 'drizzle';

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

	onMount(async () => {
		// provider = await getDrizzleProvider();
		provider = await getWCProvider();
		/*
		provider.eth.defaultCommon = {
			customChain: {
				name: "ganache",
				chainId: 100,
				networkId: 100,
			}
		};
		*/
		//provider = new Web3('http://192.168.1.24:8545');

		/*
		const drizzleStore = generateStore(options);
		drizzle = new Drizzle(options, drizzleStore);

		drizzleStore.subscribe(() => {
			state = drizzleStore.getState();
		});

		window.drizzle = drizzle;
		window.drizzleStore = drizzleStore;
		*/
		window.provider = provider;
	});

</script>

<main>
	<h1>kettle</h1>
	<button on:click={handleClick}>
		Sign Transaction
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
