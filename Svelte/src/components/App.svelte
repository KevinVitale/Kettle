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
			// from: "0x2C93d2Df11bD6B2BcFca265cadA30B457C28B15d",
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

	async function testing() {
		console.log("testing");
	}
</script>

<main>
	<h1 class='center-text'>kettle</h1>
	<h2 class='center-text'>Facilitating 32 ETH Transfers for ETH 2.0 Validators</h2>
	<div class='center-text'>
	<image class='center-text' src='https://www.ethdenver.com/wp-content/themes/understrap/img/peeking-bufficorn.png'/>
	<button on:click={handleClickSend}>
		Deposit ETH
	</button>
	<button on:click={handleClickSend}>
		Deposit ETH
	</button>
	</div>
	<p class='center-text'>Here is text so Mike doesn't have to worry about translation issues.</p>
	<!--
	<ul>
	{#each Object.values(contracts) as contract, i}
		<p>
			<li>{ JSON.stringify(contract, null, 2) }</li>
		</p>
	{:else}
		Loading...
	{/each}
	</ul>
	-->
</main>


<style>
	old-main {
		text-align: center;
		padding: 1em;
		width: 500px;
		margin: 0 auto;
	}

	h1 {
		color: #3D286B;
		text-transform: uppercase;
		font-size: 5em;
		font-weight: 100;
	}

	h2 {
		color: #3D286B;
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

  :global(html),
  :global(body),
  :global(main) {
	background: lightgray;
    height: 100%;
    margin: 0;
    width: 100%;
  }
  :global(body) {
    font-family: canada-type-gibson, sans-serif;
  }

  .btn {
    align-items: center;
    background-color: #fc5090;
    border-radius: 3px;
    border: none;
    cursor: pointer;
    display: flex;
    font-size: 16px;
    justify-content: center;
    letter-spacing: 0.25em;
    max-width: 200px;
    padding: 10px;
    text-decoration: none;
	text-decoration: uppercase;
  }

  .card {
    background-color: #fff;
    color: rgba(82, 72, 93, 0.7);
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    margin: 10px 0;
    padding: 20px;
    text-align: left;
    width: 250px;
  }

  .card a {
    text-decoration: none;
  }

  .card img {
    margin-bottom: 8px;
  }
  .card-list {
    font-size: 20px;
    margin: 20px 0;
  }

  .card-list a {
    color: inherit;
    font-weight: 500;
  }

  .card-list li {
    align-items: center;
    display: flex;
    margin: 10px;
  }

  .card-list svg {
    margin-right: 10px;
  }

  .center-text {
    text-align: center;
  }

  .column {
    display: flex;
    flex-direction: column;
  }

  .container {
    margin: 0 auto;
    max-width: 1200px;
    padding: 50px;
  }

  .container-sm {
    width: 80%;
    margin: 0 auto;
  }

  .flex-center {
    align-items: center;
    display: flex;
    justify-content: center;
  }

  .grid {
    display: flex;
    flex-wrap: wrap;
  }

  .header-lg {
    font-size: 35px;
    font-weight: 300;
    margin: 20px;
  }
  
  .header-sm {
    font-size: 28px;
    font-weight: 300;
    margin: 10px;
  }

  .hero-wrapper {
    width: 66.6666666667%;
    font-size: 16px;
    background-color: #3d286b !important;
    /*color: white;*/
    border-radius: 2px;
  }

  .space-around {
    justify-content: space-around;
  }

  .space-between {
    justify-content: space-between;
  }

  .row {
    display: flex;
    flex-direction: row;
  }

  .user {
    flex: 1;
    margin: 0 20px;
    padding: 10px;
  }

  .user-label {
    font-size: 20px;
    font-weight: 300;
    margin: 5px 0;
  }

  .user-inputs input {
    border-radius: 3px;
    border: none;
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.15);
    flex: 2;
    font-size: 16px;
    padding: 8px;
  }

  .user-inputs .input-light {
    background: rgba(0, 0, 0, 0.02);
  }

  .user-inputs button {
    flex: 1;
    margin-left: 10px;
  }

  :global(button) {
	background-color: #FC5090;
	color: white;
	font-weight: bold;
	margin: 0.5em;
	padding: 1em;
	border-radius: 3em;
	width: 25%;
	font-size: 2em;
  }

    :global(button:hover) {
	background-color: #3D286B;
	color: white;
	font-weight: bold;
	margin: 0.5em;
	padding: 1em;
	border-radius: 3em;
	width: 25%;
	font-size: 2em;
  }
</style>
