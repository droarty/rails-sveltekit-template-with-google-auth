<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { auth } from '$lib/api';

	let email = $state('');
	let password = $state('');
	let error = $state('');
	let submitting = $state(false);
	let csrfToken = $state('');

	onMount(() => {
		const match = document.cookie.match(/(?:^|; )XSRF-TOKEN=([^;]*)/);
		csrfToken = match ? decodeURIComponent(match[1]) : '';
	});

	async function handleSubmit(e: SubmitEvent) {
		e.preventDefault();
		error = '';
		submitting = true;
		try {
			await auth.login(email, password);
			goto('/');
		} catch (err: unknown) {
			error = err instanceof Error ? err.message : 'Login failed';
		} finally {
			submitting = false;
		}
	}
</script>

<main>
	<h1>Sign in</h1>

	{#if error}
		<p class="error">{error}</p>
	{/if}

	<form onsubmit={handleSubmit}>
		<label>
			Email
			<input type="email" bind:value={email} required autocomplete="email" />
		</label>

		<label>
			Password
			<input type="password" bind:value={password} required autocomplete="current-password" />
		</label>

		<button type="submit" disabled={submitting}>
			{submitting ? 'Signing in…' : 'Sign in'}
		</button>
	</form>

	<div class="divider">or</div>

	<form method="POST" action="/api/v1/auth/auth/google_oauth2">
		<input type="hidden" name="authenticity_token" value={csrfToken} />
		<button type="submit" class="google-btn">Sign in with Google</button>
	</form>
</main>

<style>
	main {
		max-width: 360px;
		margin: 4rem auto;
		padding: 1rem;
	}
	form {
		display: flex;
		flex-direction: column;
		gap: 1rem;
	}
	label {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}
	.error {
		color: red;
	}
	.divider {
		text-align: center;
		margin: 1rem 0;
		color: #666;
	}
	.google-btn {
		width: 100%;
	}
</style>
