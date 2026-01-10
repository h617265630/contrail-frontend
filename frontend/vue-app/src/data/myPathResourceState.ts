export type MyPathResourceEntry = {
  note: string
  progress: number // 0-100
}

export type MyPathResourceState = Record<string, Record<string, MyPathResourceEntry>>

const STORAGE_KEY = 'myPaths.resourceState.v1'

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

export function loadMyPathResourceState(): MyPathResourceState {
  const storage = getStorage()
  const raw = storage?.getItem?.(STORAGE_KEY) ?? null
  const parsed = safeJsonParse<MyPathResourceState>(raw)
  return parsed ?? {}
}

export function saveMyPathResourceState(state: MyPathResourceState) {
  const storage = getStorage()
  storage?.setItem?.(STORAGE_KEY, JSON.stringify(state))
}

export function getMyPathResourceEntry(
  state: MyPathResourceState,
  pathId: string,
  resourceId: string,
): MyPathResourceEntry {
  return state[pathId]?.[resourceId] ?? { note: '', progress: 0 }
}

export function setMyPathResourceEntry(
  state: MyPathResourceState,
  pathId: string,
  resourceId: string,
  entry: MyPathResourceEntry,
): MyPathResourceState {
  const next: MyPathResourceState = { ...state }
  const pathMap = { ...(next[pathId] ?? {}) }
  pathMap[resourceId] = {
    note: entry.note,
    progress: Math.max(0, Math.min(100, Math.round(entry.progress))),
  }
  next[pathId] = pathMap
  return next
}
