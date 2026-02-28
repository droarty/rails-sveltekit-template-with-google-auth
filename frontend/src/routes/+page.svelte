<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { auth } from '$lib/api';

	let user = $state<{ id: number; email: string } | null>(null);
	let loading = $state(true);

	onMount(async () => {
		try {
			const data = await auth.currentUser();
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
		<h1>Curriculum Mapper</h1>
		<p>Welcome, {user.email}!</p>
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
