import adapter from '@sveltejs/adapter-static';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter({
			pages: '../public/frontend',
			assets: '../public/frontend',
			fallback: 'index.html',
			precompress: false
		})
	}
};

export default config;
