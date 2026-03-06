export type ClassValue = string | number | null | undefined | false | ClassValue[] | { [klass: string]: boolean | null | undefined };

function toString(val: ClassValue): string {
  if (!val) return ''
  if (Array.isArray(val)) return val.map(toString).filter(Boolean).join(' ')
  if (typeof val === 'object') return Object.entries(val).filter(([, v]) => Boolean(v)).map(([k]) => k).join(' ')
  return String(val)
}

export function cn(...inputs: ClassValue[]): string {
  return inputs.map(toString).filter(Boolean).join(' ').replace(/\s+/g, ' ').trim()
}
