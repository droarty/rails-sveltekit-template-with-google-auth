<script lang="ts">
	import { onMount } from 'svelte';
	import favicon from '$lib/assets/favicon.svg';

	let { children } = $props();

	onMount(async () => {
		const hasCsrf = document.cookie.includes('XSRF-TOKEN');
		if (!hasCsrf) {
			try {
				await fetch('/api/v1/csrf', { credentials: 'include' });
			} catch {
				// Non-fatal: CSRF cookie will be set on next server-rendered response
			}
		}
	});
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

{@render children()}
