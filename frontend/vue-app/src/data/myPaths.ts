import type { Resource } from './resources'

export type MyLearningPath = {
  id: string
  title: string
  description: string
  resourceIds: string[]
  createdAt: string
  updatedAt: string
}

const STORAGE_KEY = 'myPaths.v1'

function safeJsonParse<T>(raw: string | null): T | null {
  if (!raw) return null
  try {
    return JSON.parse(raw) as T
  } catch {
    return null
  }
}

function nowIso() {
  return new Date().toISOString()
}

export function generateMyLearningPathId() {
  // crypto.randomUUID is supported in modern browsers; keep a fallback.
  try {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const maybeCrypto = (globalThis as any).crypto
    if (maybeCrypto?.randomUUID) return maybeCrypto.randomUUID()
  } catch {
    // ignore
  }
  return `lp_${Date.now()}_${Math.random().toString(16).slice(2)}`
}

export function listMyLearningPaths(): MyLearningPath[] {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const storage = (globalThis as any).localStorage
  const raw = storage?.getItem?.(STORAGE_KEY) ?? null
  const parsed = safeJsonParse<MyLearningPath[]>(raw)
  if (!parsed) return []
  return parsed.filter(p => typeof p?.id === 'string' && typeof p?.title === 'string')
}

export function getMyLearningPath(id: string): MyLearningPath | null {
  return listMyLearningPaths().find(p => p.id === id) ?? null
}

export function saveMyLearningPaths(paths: MyLearningPath[]) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const storage = (globalThis as any).localStorage
  storage?.setItem?.(STORAGE_KEY, JSON.stringify(paths))
}

export function addMyLearningPath(input: {
  title: string
  description: string
  resources: Resource[]
}): MyLearningPath {
  const createdAt = nowIso()
  const newPath: MyLearningPath = {
    id: generateMyLearningPathId(),
    title: input.title.trim(),
    description: input.description.trim(),
    resourceIds: input.resources.map(r => r.id),
    createdAt,
    updatedAt: createdAt,
  }

  const existing = listMyLearningPaths()
  saveMyLearningPaths([newPath, ...existing])
  return newPath
}

export function updateMyLearningPath(
  id: string,
  patch: Partial<Pick<MyLearningPath, 'title' | 'description' | 'resourceIds'>>,
): MyLearningPath {
  const existing = listMyLearningPaths()
  const idx = existing.findIndex(p => p.id === id)
  if (idx < 0) {
    throw new Error('LearningPath not found')
  }

  const updated: MyLearningPath = {
    ...existing[idx],
    ...patch,
    title: (patch.title ?? existing[idx].title).trim(),
    description: (patch.description ?? existing[idx].description).trim(),
    updatedAt: nowIso(),
  }

  const next = [...existing]
  next[idx] = updated
  saveMyLearningPaths(next)
  return updated
}

export function deleteMyLearningPath(id: string) {
  const existing = listMyLearningPaths()
  const next = existing.filter(p => p.id !== id)
  saveMyLearningPaths(next)
}
