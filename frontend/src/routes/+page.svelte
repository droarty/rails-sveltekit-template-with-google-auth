<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { auth } from '$lib/api';

	let user = $state<{ id: number; email: string; role: string } | null>(null);
	let loading = $state(true);

	onMount(async () => {
		try {
			const data = await auth.currentUser();
			if (data.user.role === 'superuser') {
				goto('/superuser');
				return;
			}
			if (data.user.role === 'author') {
				goto('/author');
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
		<h1>Curriculum Mapper</h1>
		<p>Welcome, {user.email}!</p>
		<button
			onclick={async () => {
				try {
					await auth.logout();
				} finally {
					goto('/login');
				}
			}}
		>
			Sign out
		</button>
	</main>
{/if}
