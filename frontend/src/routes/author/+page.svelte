<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { auth } from '$lib/api';

	let user = $state<{ id: number; email: string; role: string } | null>(null);
	let loading = $state(true);

	const allowed = ['author', 'superuser'];

	onMount(async () => {
		try {
			const data = await auth.currentUser();
			if (!allowed.includes(data.user.role)) {
				goto('/');
				return;
			}
			user = data.user;
		} catch {
			goto('/login');
		} finally {
			loading = false;
		}
	});
</script>

{#if loading}
	<p>Loading…</p>
{:else if user}
	<main>
		<h1>Author Dashboard</h1>
		<p>Signed in as {user.email}</p>
		<button
			onclick={async () => {
				await auth.logout();
				goto('/login');
			}}
		>
			Sign out
		</button>
	</main>
{/if}

<style>
	main {
		max-width: 960px;
		margin: 4rem auto;
		padding: 1rem;
	}
</style>
