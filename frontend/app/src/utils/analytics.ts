import type { Router } from 'vue-router'
import type { UserProfile } from '../api/user'

declare global {
  interface Window {
    dataLayer?: Array<Record<string, unknown>>
    gtag?: (...args: unknown[]) => void
  }
}

const GA_MEASUREMENT_ID = String(import.meta.env.VITE_GA_MEASUREMENT_ID || '').trim()
const SITE_URL = String(import.meta.env.VITE_SITE_URL || 'https://learnpathly.com').trim().replace(/\/$/, '')

let initialized = false

function ensureScriptTag(measurementId: string) {
  if (typeof document === 'undefined') return
  const existing = document.querySelector(`script[data-ga-id="${measurementId}"]`)
  if (existing) return

  const script = document.createElement('script')
  script.async = true
  script.src = `https://www.googletagmanager.com/gtag/js?id=${encodeURIComponent(measurementId)}`
  script.dataset.gaId = measurementId
  document.head.appendChild(script)
}

export function initAnalytics() {
  if (initialized || !GA_MEASUREMENT_ID || typeof window === 'undefined') return

  ensureScriptTag(GA_MEASUREMENT_ID)
  window.dataLayer = window.dataLayer || []
  window.gtag = window.gtag || function gtag(...args: unknown[]) {
    window.dataLayer?.push(args as unknown as Record<string, unknown>)
  }

  window.gtag('js', new Date())
  window.gtag('config', GA_MEASUREMENT_ID, {
    send_page_view: false,
    anonymize_ip: true,
  })

  initialized = true
}

function normalizedPath(path: string) {
  return path.startsWith('/') ? path : `/${path}`
}

export function trackPageView(path: string, title?: string) {
  if (!GA_MEASUREMENT_ID || typeof window === 'undefined' || typeof window.gtag !== 'function') return
  const finalPath = normalizedPath(path || window.location.pathname || '/')
  window.gtag('event', 'page_view', {
    page_title: title || document.title,
    page_location: `${SITE_URL}${finalPath}`,
    page_path: finalPath,
  })
}

export function setAnalyticsUser(user: UserProfile | null) {
  if (!GA_MEASUREMENT_ID || typeof window === 'undefined' || typeof window.gtag !== 'function') return
  if (user?.id) {
    window.gtag('config', GA_MEASUREMENT_ID, {
      user_id: String(user.id),
    })
    return
  }
  window.gtag('config', GA_MEASUREMENT_ID, {
    user_id: undefined,
  })
}

export function installAnalytics(router: Router) {
  initAnalytics()
  if (!GA_MEASUREMENT_ID) return

  router.afterEach((to) => {
    const title = typeof to.meta?.title === 'string' ? to.meta.title : document.title
    trackPageView(String(to.path || '/'), title)
  })
}

export function analyticsEnabled() {
  return !!GA_MEASUREMENT_ID
}
