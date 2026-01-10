export type LearningPathComment = {
  id: string
  text: string
  createdAt: string
}

type CommentsByPathId = Record<string, LearningPathComment[]>

const STORAGE_KEY = 'learningPath.comments.v1'

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

function generateId() {
  try {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const maybeCrypto = (globalThis as any).crypto
    if (maybeCrypto?.randomUUID) return maybeCrypto.randomUUID()
  } catch {
    // ignore
  }
  return `c_${Date.now()}_${Math.random().toString(16).slice(2)}`
}

function getStorage() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  return (globalThis as any).localStorage
}

export function listLearningPathComments(pathId: string): LearningPathComment[] {
  const storage = getStorage()
  const raw = storage?.getItem?.(STORAGE_KEY) ?? null
  const parsed = safeJsonParse<CommentsByPathId>(raw) ?? {}
  const list = parsed[pathId]
  return Array.isArray(list) ? list : []
}

export function addLearningPathComment(pathId: string, text: string): LearningPathComment {
  const trimmed = text.trim()
  if (!trimmed) throw new Error('Empty comment')

  const storage = getStorage()
  const raw = storage?.getItem?.(STORAGE_KEY) ?? null
  const parsed = safeJsonParse<CommentsByPathId>(raw) ?? {}

  const nextComment: LearningPathComment = {
    id: generateId(),
    text: trimmed,
    createdAt: nowIso(),
  }

  const existing = Array.isArray(parsed[pathId]) ? parsed[pathId] : []
  parsed[pathId] = [nextComment, ...existing]

  storage?.setItem?.(STORAGE_KEY, JSON.stringify(parsed))
  return nextComment
}
