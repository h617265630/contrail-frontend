export type PlanName = 'Free' | 'Basic' | 'Pro'

export type PlanInfo = {
  name: PlanName
  /** ISO string */
  purchased_at: string | null
  /** Total purchased duration in days; null/0 means not applicable */
  duration_days: number | null
  /** Human-readable permissions/features included in this plan */
  permissions: string[]
}

const STORAGE_KEY = 'learnsmart_plan_info_v1'
const LEGACY_NAME_KEY = 'learnsmart_plan'

const PERMISSIONS_BY_PLAN: Record<PlanName, string[]> = {
  Free: ['View public resources', 'Preview learning paths', 'Local notes'],
  Basic: ['All learning paths', 'Manage resources', 'Cloud notes sync', 'Progress tracking & export'],
  Pro: ['Team collaboration & sharing', 'Custom paths & templates', 'Advanced search & filters', 'Priority support'],
}

export function makePlanInfo(name: PlanName, purchasedAtIso: string | null, durationDays: number | null): PlanInfo {
  return {
    name,
    purchased_at: purchasedAtIso,
    duration_days: durationDays,
    permissions: PERMISSIONS_BY_PLAN[name] || [],
  }
}

function safeParseJson(raw: string): any {
  try {
    return JSON.parse(raw)
  } catch {
    return null
  }
}

export function getPlanInfo(): PlanInfo {
  try {
    const storage = (globalThis as any).localStorage

    const raw = String(storage?.getItem(STORAGE_KEY) || '').trim()
    if (raw) {
      const parsed = safeParseJson(raw)
      const name = (String(parsed?.name || '').trim() as PlanName) || 'Free'
      const purchasedAt = parsed?.purchased_at ? String(parsed.purchased_at) : null
      const durationDays = parsed?.duration_days == null ? null : Number(parsed.duration_days)
      const permissions = Array.isArray(parsed?.permissions) ? parsed.permissions.map((x: any) => String(x)) : null

      const normalized: PlanInfo = {
        name: ['Free', 'Basic', 'Pro'].includes(name) ? name : 'Free',
        purchased_at: purchasedAt && purchasedAt.trim() ? purchasedAt : null,
        duration_days: Number.isFinite(durationDays as any) ? (durationDays as number) : null,
        permissions: permissions && permissions.length ? permissions : PERMISSIONS_BY_PLAN[['Free', 'Basic', 'Pro'].includes(name) ? name : 'Free'],
      }
      return normalized
    }

    // Backward compatibility: old key stored only plan name
    const legacyName = String(storage?.getItem(LEGACY_NAME_KEY) || '').trim() as PlanName
    if (legacyName && (legacyName === 'Free' || legacyName === 'Basic' || legacyName === 'Pro')) {
      return makePlanInfo(legacyName, null, null)
    }

    return makePlanInfo('Free', null, null)
  } catch {
    return makePlanInfo('Free', null, null)
  }
}

export function setPlanInfo(info: PlanInfo) {
  try {
    const storage = (globalThis as any).localStorage
    storage?.setItem(STORAGE_KEY, JSON.stringify(info))
    // Keep legacy key in sync for older reads
    storage?.setItem(LEGACY_NAME_KEY, info.name)
  } catch {
    // ignore
  }
}

export function selectPlan(name: PlanName) {
  const nowIso = new Date().toISOString()

  if (name === 'Free') {
    setPlanInfo(makePlanInfo('Free', null, null))
    return
  }

  // Minimal purchase model: Basic = 30 days, Pro = 365 days
  const durationDays = name === 'Basic' ? 30 : 365
  setPlanInfo(makePlanInfo(name, nowIso, durationDays))
}

export function formatIsoDate(iso: string | null): string {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

export function daysBetween(aIso: string, bIso: string): number {
  const a = new Date(aIso).getTime()
  const b = new Date(bIso).getTime()
  if (!Number.isFinite(a) || !Number.isFinite(b)) return 0
  const diff = Math.max(0, b - a)
  return Math.floor(diff / (24 * 60 * 60 * 1000))
}

export function addDaysIso(iso: string, days: number): string {
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return iso
  d.setDate(d.getDate() + days)
  return d.toISOString()
}
