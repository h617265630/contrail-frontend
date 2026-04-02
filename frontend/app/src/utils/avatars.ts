const STORAGE_PREFIX = 'learnpathly_default_avatar:'

function safeGetStorage() {
  try {
    return (globalThis as any).localStorage
  } catch {
    return null
  }
}

function svgDataUri(svg: string) {
  const encoded = encodeURIComponent(svg)
    .replace(/%0A/g, '')
    .replace(/%20/g, ' ')
    .replace(/%3D/g, '=')
    .replace(/%3A/g, ':')
    .replace(/%2F/g, '/')
    .replace(/%22/g, "'")
  return `data:image/svg+xml,${encoded}`
}

const AVATARS = [
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#93c5fd"/><path d="M14 42c10-10 22-22 36-22" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><path d="M24 46c8-8 16-16 26-18" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".9"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#a5b4fc"/><path d="M12 38c12-12 26-18 40-16" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><circle cx="46" cy="22" r="3" fill="#fff"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#7dd3fc"/><path d="M14 26c14 0 20 6 36 22" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><path d="M14 34c12 0 18 6 30 18" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".85"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#bae6fd"/><path d="M18 44c10-18 18-24 28-24" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><circle cx="42" cy="20" r="3" fill="#fff"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#93c5fd"/><path d="M16 40c8-8 16-14 32-16" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><path d="M20 46c6-6 14-10 26-12" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".85"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#a5b4fc"/><path d="M16 28c8 2 16 10 32 24" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><circle cx="18" cy="28" r="3" fill="#fff"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#7dd3fc"/><path d="M14 44c14-14 26-22 38-22" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><path d="M14 50c10-10 20-16 30-16" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".85"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#bae6fd"/><path d="M18 22c10 6 18 16 28 28" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><path d="M22 20c10 6 18 14 26 24" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".85"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#93c5fd"/><path d="M14 36c16-16 28-18 36-18" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><circle cx="50" cy="18" r="3" fill="#fff"/></svg>`),
  svgDataUri(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="16" fill="#a5b4fc"/><path d="M14 46c10-10 22-18 38-20" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/><path d="M14 52c8-8 18-14 30-16" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".85"/></svg>`),
] as const

export function getDefaultAvatars() {
  return [...AVATARS]
}

export function getOrCreateDefaultAvatarForUser(userId: number) {
  const storage = safeGetStorage()
  const key = `${STORAGE_PREFIX}${userId}`
  const existing = storage?.getItem(key)
  if (existing) return existing

  const pick = AVATARS[Math.floor(Math.random() * AVATARS.length)]
  try {
    storage?.setItem(key, pick)
  } catch {
    // ignore
  }
  return pick
}
