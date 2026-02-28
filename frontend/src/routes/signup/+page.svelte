<script lang="ts">
	import { goto } from '$app/navigation';
	import { auth } from '$lib/api';

	let email = $state('');
	let password = $state('');
	let passwordConfirmation = $state('');
	let error = $state('');
	let submitting = $state(false);

	async function handleSubmit(e: SubmitEvent) {
		e.preventDefault();
		error = '';
		submitting = true;
		try {
			await auth.register(email, password, passwordConfirmation);
			goto('/');
		} catch (err: unknown) {
			if (err instanceof Error && 'body' in err) {
				const body = (err as { body: { errors?: string[] } }).body;
				error = body.errors?.join(', ') ?? err.message;
			} else {
				error = err instanceof Error ? err.message : 'Registration failed';
			}
		} finally {
			submitting = false;
		}
	}
</script>

<main>
	<h1>Create account</h1>

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
			<input type="password" bind:value={password} required autocomplete="new-password" />
		</label>

		<label>
			Confirm password
			<input type="password" bind:value={passwordConfirmation} required autocomplete="new-password" />
		</label>

		<button type="submit" disabled={submitting}>
			{submitting ? 'Creating account…' : 'Create account'}
		</button>
	</form>

	<p class="login-link">Already have an account? <a href="/login">Sign in</a></p>
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
	.login-link {
		margin-top: 1rem;
		text-align: center;
	}
</style>
