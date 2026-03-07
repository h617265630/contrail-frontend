const API_BASE = String(import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000').replace(/\/$/, '')

export function toBackendAbsoluteUrl(input: string): string {
  const explicit = String(input || '').trim()
  if (!explicit) return ''
  if (explicit.startsWith('http://') || explicit.startsWith('https://')) return explicit
  return `${API_BASE}${explicit.startsWith('/') ? '' : '/'}${explicit}`
}
