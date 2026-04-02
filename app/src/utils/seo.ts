import type { Router, RouteLocationNormalizedLoaded } from 'vue-router'

const SITE_NAME = 'Learnpathly'
const SITE_URL = String(import.meta.env.VITE_SITE_URL || 'https://www.learnpathly.com').trim().replace(/\/$/, '')
const DEFAULT_DESCRIPTION = 'Learnpathly helps you discover resources, build learning paths, and generate AI-guided study plans.'

interface SeoMeta {
  title: string
  description: string
  noindex?: boolean
  type?: 'website' | 'article' | 'profile'
}

interface RouteSeoMeta {
  seo?: SeoMeta
}

function ensureMetaTag(name: string): HTMLMetaElement {
  let node = document.head.querySelector(`meta[name="${name}"]`) as HTMLMetaElement | null
  if (!node) {
    node = document.createElement('meta')
    node.setAttribute('name', name)
    document.head.appendChild(node)
  }
  return node
}

function ensurePropertyMetaTag(property: string): HTMLMetaElement {
  let node = document.head.querySelector(`meta[property="${property}"]`) as HTMLMetaElement | null
  if (!node) {
    node = document.createElement('meta')
    node.setAttribute('property', property)
    document.head.appendChild(node)
  }
  return node
}

function ensureCanonicalTag(): HTMLLinkElement {
  let node = document.head.querySelector('link[rel="canonical"]') as HTMLLinkElement | null
  if (!node) {
    node = document.createElement('link')
    node.setAttribute('rel', 'canonical')
    document.head.appendChild(node)
  }
  return node
}

function updateStructuredData(type: string, data: Record<string, any>) {
  let script = document.head.querySelector(`script[data-seo-type="${type}"]`) as HTMLScriptElement | null
  if (!script) {
    script = document.createElement('script')
    script.setAttribute('type', 'application/ld+json')
    script.setAttribute('data-seo-type', type)
    document.head.appendChild(script)
  }
  script.textContent = JSON.stringify(data)
}

export function applySeo(route: RouteLocationNormalizedLoaded) {
  if (typeof document === 'undefined') return

  const meta = (route.meta as RouteSeoMeta)?.seo
  const title = meta?.title || SITE_NAME
  const description = meta?.description || DEFAULT_DESCRIPTION
  const noindex = meta?.noindex ?? false
  const type = meta?.type || 'website'
  const fullTitle = title.includes(SITE_NAME) ? title : `${title} - ${SITE_NAME}`
  const canonicalPath = String(route.path || '/home')
  const canonicalUrl = `${SITE_URL}${canonicalPath.startsWith('/') ? canonicalPath : `/${canonicalPath}`}`

  // Title
  document.title = fullTitle

  // Meta description
  ensureMetaTag('description').setAttribute('content', description)

  // Robots
  ensureMetaTag('robots').setAttribute('content', noindex ? 'noindex, nofollow' : 'index, follow')

  // Canonical URL
  ensureCanonicalTag().setAttribute('href', canonicalUrl)

  // Open Graph tags
  ensurePropertyMetaTag('og:type').setAttribute('content', type)
  ensurePropertyMetaTag('og:title').setAttribute('content', fullTitle)
  ensurePropertyMetaTag('og:description').setAttribute('content', description)
  ensurePropertyMetaTag('og:url').setAttribute('content', canonicalUrl)
  ensurePropertyMetaTag('og:site_name').setAttribute('content', SITE_NAME)

  // Twitter Card tags
  ensureMetaTag('twitter:card').setAttribute('content', 'summary_large_image')
  ensureMetaTag('twitter:title').setAttribute('content', fullTitle)
  ensureMetaTag('twitter:description').setAttribute('content', description)
  ensureMetaTag('twitter:site').setAttribute('content', '@learnpathly')

  // Route-specific structured data
  const routeName = route.name as string

  if (routeName === 'learningpath' || routeName === 'learningpath-detail') {
    // LearningPath schema
    updateStructuredData('learningpath', {
      '@context': 'https://schema.org',
      '@type': 'Course',
      name: title,
      description: description,
      url: canonicalUrl,
      provider: {
        '@type': 'Organization',
        name: SITE_NAME,
        url: SITE_URL,
      },
    })
  } else if (routeName === 'resource-video' || routeName === 'resource-article' || routeName === 'resource-document') {
    // Resource schema
    updateStructuredData('resource', {
      '@context': 'https://schema.org',
      '@type': 'LearningResource',
      name: title,
      description: description,
      url: canonicalUrl,
      provider: {
        '@type': 'Organization',
        name: SITE_NAME,
        url: SITE_URL,
      },
    })
  } else if (routeName === 'learningpool' || routeName === 'learningpool-category') {
    // Collection page schema
    updateStructuredData('collection', {
      '@context': 'https://schema.org',
      '@type': 'CollectionPage',
      name: fullTitle,
      description: description,
      url: canonicalUrl,
    })
  } else if (routeName === 'home') {
    // WebSite schema for homepage
    updateStructuredData('website', {
      '@context': 'https://schema.org',
      '@type': 'WebSite',
      name: SITE_NAME,
      url: SITE_URL,
      description: description,
      potentialAction: {
        '@type': 'SearchAction',
        target: {
          '@type': 'EntryPoint',
          urlTemplate: `${SITE_URL}/resources?q={search_term_string}`,
        },
        'query-input': 'required name=search_term_string',
      },
    })
  } else {
    // Clear any page-specific structured data for routes without specific schema
    const existingScript = document.head.querySelector('script[data-seo-type]')
    if (existingScript) {
      // Only remove non-Organization scripts
      const orgScript = document.head.querySelector('script[data-seo-type="organization"]')
      if (!orgScript) {
        existingScript.remove()
      }
    }
  }
}

export function installSeo(router: Router) {
  router.afterEach((to) => {
    applySeo(to)
  })
}
