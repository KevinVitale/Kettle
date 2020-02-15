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

	async function handleClickSend(event) {
		drizzle.contractList[0].methods.deposit(
			"0x892d3dcf44b2bbadfd93ee84cfc0e6ceeac165de0209bd6ec18c19468f54d87bd0bc15b13497f38f78bc897bb88bfb10",
			"0x19e3fd587d0fd0bdad9c62d6eae3041d963e806a97236a81e99bc0bbbe229be2",
			"0xb14429721c8d0f01b2d6ca8676f6841ad3a022a1de87073986d09b253beb946e611ad2f6ed7e1dac3804b9bbfadcaaaa0339b765ce1f43d4b838a0bc3910761fbb9d6e5b1c2fada899bf9cedc8d589621cbb0523838b0fea9c1d6c065bea30e2",
			"0x0000000000000000000000000000000000000000000000000000000000000000"
		).send({
			to: "0x91996Be8aCEE088e77512365Ffc4EE522ff9DFFA",
			from: "0x0Cbe55DF6ec0b2AD41274Dad7Ccf17fc632CF749",
			value: provider.utils.numberToHex((1 * 1e18)),
		})
		.on('transactionHash', function (hash) { console.log("Hash: " + hash); })
		.on('receipt', function (receipt) { console.log("Receipt: " + receipt); })
		.on('confirmation', function (confirmationNumber, receipt) { console.log("confirm: " + confirmationNumber, receipt); })
		.on('error', function (error) { console.log(JSON.stringify(error)); });

		/*
		provider.eth.sendTransaction({
			to: "0x91996Be8aCEE088e77512365Ffc4EE522ff9DFFA",
			from: "0x0Cbe55DF6ec0b2AD41274Dad7Ccf17fc632CF749",
			gasPrice: 20000000,
			value: provider.utils.numberToHex((1 * 1e18)),
		})
		.on('transactionHash', function (hash) { console.log("Hash: " + hash); })
		.on('receipt', function (receipt) { console.log("Receipt: " + receipt); })
		.on('confirmation', function (confirmationNumber, receipt) { console.log("confirm: " + confirmationNumber, receipt); })
		.on('error', function (error) { console.log(JSON.stringify(error)); });
		*/
	};


	async function handleClick(event) {
		provider.eth.sendTransaction({
			to: "0x91996Be8aCEE088e77512365Ffc4EE522ff9DFFA",
			from: "0x0Cbe55DF6ec0b2AD41274Dad7Ccf17fc632CF749",
			gasPrice: 20000000,
			value: provider.utils.numberToHex((1 * 1e18)),
		})
		.on('transactionHash', function (hash) { console.log("Hash: " + hash); })
		.on('receipt', function (receipt) { console.log("Receipt: " + receipt); })
		.on('confirmation', function (confirmationNumber, receipt) { console.log("confirm: " + confirmationNumber, receipt); })
		.on('error', function (error) { console.log(JSON.stringify(error)); });
	};

	onMount(async () => {
		provider = await getDrizzleProvider();
		const drizzleStore = generateStore(options);
		drizzle = new Drizzle(options, drizzleStore);

		drizzleStore.subscribe(() => {
			state = drizzleStore.getState();
		});

		window.drizzle = drizzle;
		window.drizzleStore = drizzleStore;
		window.provider = provider;
	});

	/*
	onMount(async () => {
		provider = await getWCProvider();
		window.provider = provider;
	});
	*/

</script>

<main>
	<h1>kettle</h1>
	<button on:click={handleClickSend}>
		Deposit ETH
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
