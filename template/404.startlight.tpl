---
import { getEntry } from 'astro:content';
import config from 'virtual:starlight/user-config';
import EmptyContent from './components/EmptyMarkdown.md';
import Page from './components/Page.astro';
import { generateRouteData } from './utils/route-data';
import type { StarlightDocsEntry } from './utils/routing';
import { useTranslations } from './utils/translations';

const { lang = 'en', dir = 'ltr' } = config.defaultLocale || {};
let locale = config.defaultLocale?.locale;
if (locale === 'root') locale = undefined;

const entryMeta = { dir, lang, locale };
const t = useTranslations(locale);

const fallbackEntry: StarlightDocsEntry = {
	slug: '404',
	id: '404.md' as StarlightDocsEntry['id'],
	body: '',
	collection: 'docs',
	data: {
		title: '404',
		template: 'splash',
		editUrl: false,
		head: [],
		hero: { tagline: t('404.text'), actions: [] },
		pagefind: false,
		sidebar: { hidden: false, attrs: {} },
	},
	render: async () => ({
		Content: EmptyContent,
		headings: [],
		remarkPluginFrontmatter: {},
	}),
};

const userEntry = await getEntry('docs', '404');
const entry = userEntry || fallbackEntry;
const { Content, headings } = await entry.render();
const route = generateRouteData({
	props: { ...entryMeta, entryMeta, headings, entry, id: entry.id, slug: entry.slug },
	url: Astro.url,
});
---

<Page {...route}><Content /></Page>

<script>
	const pathname = window?.location?.pathname;

	const track404 = (props)=>{ 
		const { type } = props;

		 setTimeout(function () {
			if(window.aes && window.AESPluginEvent) {
				const sendEvent = window?.aes.use(window.AESPluginEvent)
				const AES_EVENT_TYPE = {
					TRACK_404: 'TRACK_404'
				};
				sendEvent(AES_EVENT_TYPE.TRACK_404, {
					c1:  window?.location?.pathname,
					c2: type, //文档或其他
				});
			}
		 }, 1000)
	};
	if(pathname === '/zh-cn') {
		window.location.pathname = '/'
	}
	if(pathname === '/en') {
		window.location.pathname = '/en/'
	}

	if(pathname.slice(-1)!== '/'){
		window.location.pathname += '/'
	}

	// 对文档情况进行重定向
	if (pathname.includes('docs')) {
		// const regexs =/\/docs\/([^/]+)\//;
		// 	const match = regexs.exec(pathname)
		// 	if (!match) {
		// 		const [lang, rest] = pathname.split('/docs');
		// 		if(lang === '/en') {
		// 			window.location.pathname = '/en/docs'+ '/202' + rest
		// 		} else {
		// 			window.location.pathname = '/docs'+ '/latest' + rest
		// 		}
				
		// 	} else {
		// 		window.location.pathname = '/'
		// 		 // 埋点上报
		// 		track404({ type:'docs'})
		// 	}
		// window.location.pathname = '/docs/2023/overview/what-is-sca/'
		window.location.pathname = "/docs/dev/overview/";
	} else {
		window.location.pathname = '/'
		track404({type:'others'});
	}
	
</script>
