import { resourceSeed, type Resource } from './resources'

const CUSTOM_KEY = 'resources.custom.v1'
const HIDDEN_KEY = 'resources.hidden.v1'

function safeJsonParse<T>(raw: string | null): T | null {
  if (!raw) return null
  try {
    return JSON.parse(raw) as T
  } catch {
    return null
  }
}

function getStorage() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  return (globalThis as any).localStorage
}

export function listCustomResources(): Resource[] {
  const storage = getStorage()
  const raw = storage?.getItem?.(CUSTOM_KEY) ?? null
  const parsed = safeJsonParse<Resource[]>(raw)
  if (!parsed) return []
  return parsed.filter(r => typeof r?.id === 'string' && typeof r?.title === 'string')
}

export function saveCustomResources(resources: Resource[]) {
  const storage = getStorage()
  storage?.setItem?.(CUSTOM_KEY, JSON.stringify(resources))
}

export function listHiddenResourceIds(): string[] {
  const storage = getStorage()
  const raw = storage?.getItem?.(HIDDEN_KEY) ?? null
  const parsed = safeJsonParse<string[]>(raw)
  if (!parsed) return []
  return parsed.filter(id => typeof id === 'string')
}

export function saveHiddenResourceIds(ids: string[]) {
  const storage = getStorage()
  storage?.setItem?.(HIDDEN_KEY, JSON.stringify(ids))
}

export function listAllResources(): Resource[] {
  const hidden = new Set(listHiddenResourceIds())
  const seed = resourceSeed.filter(r => !hidden.has(r.id))
  const custom = listCustomResources().filter(r => !hidden.has(r.id))

  const byId = new Map<string, Resource>()
  for (const r of seed) byId.set(r.id, r)
  for (const r of custom) byId.set(r.id, r)

  // Keep display order: custom first (newest first), then the rest of seed.
  const customFirst: Resource[] = []
  for (const r of custom) customFirst.push(byId.get(r.id)!)

  const rest: Resource[] = []
  for (const r of seed) {
    if (custom.some(c => c.id === r.id)) continue
    const hit = byId.get(r.id)
    if (hit) rest.push(hit)
  }

  return [...customFirst, ...rest]
}

export function upsertResource(resource: Resource) {
  const custom = listCustomResources()
  const idx = custom.findIndex(r => r.id === resource.id)
  const next = [...custom]
  if (idx >= 0) next[idx] = resource
  else next.unshift(resource)
  saveCustomResources(next)

  // If it was hidden before, unhide it.
  const hidden = listHiddenResourceIds()
  if (hidden.includes(resource.id)) {
    saveHiddenResourceIds(hidden.filter(id => id !== resource.id))
  }
}

export function deleteResource(id: string) {
  const custom = listCustomResources()
  const nextCustom = custom.filter(r => r.id !== id)
  if (nextCustom.length !== custom.length) {
    saveCustomResources(nextCustom)
    return
  }

  const hidden = new Set(listHiddenResourceIds())
  hidden.add(id)
  saveHiddenResourceIds(Array.from(hidden))
}

export function getResourceById(id: string): Resource | null {
  return listAllResources().find(r => r.id === id) ?? null
}
