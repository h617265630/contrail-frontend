import type { Router, RouteLocationNormalizedLoaded } from 'vue-router'

const SITE_NAME = 'Learnpathly'
const SITE_URL = String(import.meta.env.VITE_SITE_URL || 'https://learnpathly.com').trim().replace(/\/$/, '')
const DEFAULT_TITLE = 'Learnpathly'
const DEFAULT_DESCRIPTION = 'Learnpathly helps you discover resources, build learning paths, and generate AI-guided study plans.'

type SeoMeta = {
  title: string
  description: string
  canonicalPath?: string
  noindex?: boolean
}

const ROUTE_META: Array<{ match: (path: string) => boolean; meta: SeoMeta }> = [
  {
    match: (path) => path === '/' || path === '/home',
    meta: {
      title: 'Learnpathly',
      description: 'Discover learning resources, organize them into paths, and generate AI-guided study plans on Learnpathly.',
      canonicalPath: '/',
    },
  },
  {
    match: (path) => path === '/resources',
    meta: {
      title: 'Resources - Learnpathly',
      description: 'Browse curated learning resources across videos, documents, and articles on Learnpathly.',
    },
  },
  {
    match: (path) => path === '/learningpool',
    meta: {
      title: 'Learning Pool - Learnpathly',
      description: 'Explore public learning paths and discover structured ways to study on Learnpathly.',
    },
  },
  {
    match: (path) => path === '/ai-path',
    meta: {
      title: 'AI Path Generator - Learnpathly',
      description: 'Describe what you want to learn and generate an AI-guided learning path with structured stages and resources.',
    },
  },
  {
    match: (path) => path === '/ai-path-detail',
    meta: {
      title: 'AI Path Detail - Learnpathly',
      description: 'Generated AI learning path details.',
      noindex: true,
    },
  },
  {
    match: (path) => path === '/plan',
    meta: {
      title: 'Plan - Learnpathly',
      description: 'Build and review your learning plans on Learnpathly.',
    },
  },
  {
    match: (path) => path === '/about' || path.startsWith('/about/'),
    meta: {
      title: 'About - Learnpathly',
      description: 'Learn how Learnpathly helps you organize resources, learning paths, and progress.',
    },
  },
  {
    match: (path) => path === '/login' || path === '/register' || path.startsWith('/account') || path.startsWith('/my-') || path.includes('/edit') || path.includes('/add'),
    meta: {
      title: 'Learnpathly',
      description: DEFAULT_DESCRIPTION,
      noindex: true,
    },
  },
]

function ensureMetaTag(name: string) {
  let node = document.head.querySelector(`meta[name="${name}"]`) as HTMLMetaElement | null
  if (!node) {
    node = document.createElement('meta')
    node.setAttribute('name', name)
    document.head.appendChild(node)
  }
  return node
}

function ensureCanonicalTag() {
  let node = document.head.querySelector('link[rel="canonical"]') as HTMLLinkElement | null
  if (!node) {
    node = document.createElement('link')
    node.setAttribute('rel', 'canonical')
    document.head.appendChild(node)
  }
  return node
}

function ensureOgTag(property: string) {
  let node = document.head.querySelector(`meta[property="${property}"]`) as HTMLMetaElement | null
  if (!node) {
    node = document.createElement('meta')
    node.setAttribute('property', property)
    document.head.appendChild(node)
  }
  return node
}

function getSeoMeta(route: RouteLocationNormalizedLoaded): SeoMeta {
  const path = String(route.path || '/home')
  for (const entry of ROUTE_META) {
    if (entry.match(path)) return entry.meta
  }
  return {
    title: DEFAULT_TITLE,
    description: DEFAULT_DESCRIPTION,
    canonicalPath: path,
  }
}

export function applySeo(route: RouteLocationNormalizedLoaded) {
  if (typeof document === 'undefined') return

  const meta = getSeoMeta(route)
  const title = meta.title.includes(SITE_NAME) ? meta.title : `${meta.title} - ${SITE_NAME}`
  const description = meta.description || DEFAULT_DESCRIPTION
  const canonicalPath = meta.canonicalPath || String(route.path || '/home')
  const robots = meta.noindex ? 'noindex, nofollow' : 'index, follow'

  document.title = title
  ensureMetaTag('description').setAttribute('content', description)
  ensureMetaTag('robots').setAttribute('content', robots)
  ensureCanonicalTag().setAttribute('href', `${SITE_URL}${canonicalPath.startsWith('/') ? canonicalPath : `/${canonicalPath}`}`)
  ensureOgTag('og:title').setAttribute('content', title)
  ensureOgTag('og:description').setAttribute('content', description)
  ensureOgTag('og:type').setAttribute('content', 'website')
  ensureOgTag('og:url').setAttribute('content', `${SITE_URL}${canonicalPath.startsWith('/') ? canonicalPath : `/${canonicalPath}`}`)
}

export function installSeo(router: Router) {
  router.afterEach((to) => {
    applySeo(to)
  })
}
