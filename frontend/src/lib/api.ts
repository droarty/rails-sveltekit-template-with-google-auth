function getCsrfToken(): string {
	const match = document.cookie.match(/(?:^|;\s*)XSRF-TOKEN=([^;]+)/);
	return match ? decodeURIComponent(match[1]) : '';
}

async function request<T>(
	url: string,
	options: RequestInit = {}
): Promise<T> {
	const method = (options.method ?? 'GET').toUpperCase();
	const mutating = ['POST', 'PUT', 'PATCH', 'DELETE'].includes(method);

	const headers = new Headers(options.headers);
	headers.set('Content-Type', 'application/json');
	headers.set('Accept', 'application/json');

	if (mutating) {
		const token = getCsrfToken();
		if (token) headers.set('X-CSRF-Token', token);
	}

	const response = await fetch(url, {
		...options,
		headers,
		credentials: 'include'
	});

	if (!response.ok) {
		const body = await response.json().catch(() => ({}));
		throw Object.assign(new Error(body.error ?? response.statusText), { status: response.status, body });
	}

	return response.json() as Promise<T>;
}

export const auth = {
	register(email: string, password: string, passwordConfirmation: string) {
		return request<{ user: { id: number; email: string; role: string } }>('/api/v1/auth', {
			method: 'POST',
			body: JSON.stringify({ user: { email, password, password_confirmation: passwordConfirmation } })
		});
	},

	login(email: string, password: string) {
		return request<{ user: { id: number; email: string } }>('/api/v1/auth/sign_in', {
			method: 'POST',
			body: JSON.stringify({ user: { email, password } })
		});
	},

	logout() {
		return request<{ message: string }>('/api/v1/auth/sign_out', {
			method: 'DELETE'
		});
	},

	currentUser() {
		return request<{ user: { id: number; email: string; role: string } }>('/api/v1/me');
	}
};

export default request;
