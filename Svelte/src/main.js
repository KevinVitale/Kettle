import App from './components/App.svelte';

const app = new App({
	target: document.body,
	props: { }
 });

/*
getProvider()
  // .then((p) => { p.eth.net.getId(); })
  .then((p) => {
    const drizzleStore = generateStore(options);
    const drizzle = new Drizzle(options, drizzleStore);

    drizzleStore.subscribe(() => {
      const state = drizzleStore.getState();
      app.$set({ state });
    });

    // This is not necessary, but I find it useful to be able to interact with these objects
    // from the console window when I'm trying things out and debugging.
    window.drizzle = drizzle;
    window.store = drizzleStore;
    window.app = app
  })
*/

export default app;
