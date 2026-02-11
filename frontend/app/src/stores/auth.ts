import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import type { UserProfile } from '../api/user'
import { getCurrentUser } from '../api/user'

// Lightweight auth state: store token + user profile so any component (e.g. NavBar) can read shared state.
// Use globalThis.localStorage to avoid TS build errors when DOM lib types are not available.
const TOKEN_KEY = 'learnsmart_token'
const USER_KEY = 'learnsmart_user'
const REMEMBER_KEY = 'learnsmart_remember'

function getLocalStorage() {
  try {
    return (globalThis as any).localStorage
  } catch {
    return null
  }
}

function getSessionStorage() {
  try {
    return (globalThis as any).sessionStorage
  } catch {
    return null
  }
}

function isRememberedPref(): boolean {
  try {
    const storage = getLocalStorage()
    return storage?.getItem(REMEMBER_KEY) === '1'
  } catch {
    return false
  }
}

function setRememberedPref(next: boolean) {
  try {
    const storage = getLocalStorage()
    if (!storage) return
    if (next) {
      storage.setItem(REMEMBER_KEY, '1')
    } else {
      storage.removeItem(REMEMBER_KEY)
    }
  } catch {
    return
  }
}

function hasLocalToken(): boolean {
  try {
    const storage = getLocalStorage()
    return !!storage?.getItem(TOKEN_KEY)
  } catch {
    return false
  }
}

function readToken(): string | null {
  try {
    const local = getLocalStorage()
    const session = getSessionStorage()
    return local?.getItem(TOKEN_KEY) || session?.getItem(TOKEN_KEY) || null
  } catch {
    return null
  }
}

function readUser(): UserProfile | null {
  try {
    const local = getLocalStorage()
    const session = getSessionStorage()
    const raw = local?.getItem(USER_KEY) || session?.getItem(USER_KEY)
    return raw ? (JSON.parse(raw) as UserProfile) : null
  } catch {
    return null
  }
}

function persistToken(next: string | null, remember?: boolean) {
  try {
    const local = getLocalStorage()
    const session = getSessionStorage()
    if (!next) {
      local?.removeItem(TOKEN_KEY)
      session?.removeItem(TOKEN_KEY)
      setRememberedPref(false)
      return
    }

    const shouldRemember = typeof remember === 'boolean' ? remember : (hasLocalToken() || isRememberedPref())
    setRememberedPref(shouldRemember)
    if (shouldRemember) {
      local?.setItem(TOKEN_KEY, next)
      session?.removeItem(TOKEN_KEY)
    } else {
      session?.setItem(TOKEN_KEY, next)
      local?.removeItem(TOKEN_KEY)
    }
  } catch {
    // ignore storage errors
  }
}

function persistUser(next: UserProfile | null, remember?: boolean) {
  try {
    const local = getLocalStorage()
    const session = getSessionStorage()
    if (!next) {
      local?.removeItem(USER_KEY)
      session?.removeItem(USER_KEY)
      return
    }

    const shouldRemember = typeof remember === 'boolean' ? remember : hasLocalToken()
    if (shouldRemember) {
      local?.setItem(USER_KEY, JSON.stringify(next))
      session?.removeItem(USER_KEY)
    } else {
      session?.setItem(USER_KEY, JSON.stringify(next))
      local?.removeItem(USER_KEY)
    }
  } catch {
    // ignore storage errors
  }
}

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(readToken())
  const user = ref<UserProfile | null>(readUser())
  const isAuthed = computed(() => !!token.value)
  const avatarBuster = ref(0)

  function setToken(next: string | null, remember?: boolean) {
    token.value = next
    persistToken(next, remember)
  }

  function setUser(next: UserProfile | null, remember?: boolean) {
    const prevAvatar = String((user.value as any)?.avatar_url || '').trim()
    const nextAvatar = String((next as any)?.avatar_url || '').trim()
    user.value = next
    persistUser(next, remember)
    if (next && nextAvatar && nextAvatar !== prevAvatar) {
      avatarBuster.value += 1
    }
  }

  function bumpAvatarBuster() {
    avatarBuster.value += 1
  }

  function logout() {
    setToken(null)
    setUser(null)
  }

  async function fetchProfile(force = false) {
    if (!token.value) {
      setUser(null)
      return null
    }

    if (user.value && !force) {
      return user.value
    }

    try {
      const profile = await getCurrentUser()
      setUser(profile)
      return profile
    } catch (error: any) {
      if (error?.response?.status === 401) {
        logout()
      }
      throw error
    }
  }

  return {
    token,
    user,
    avatarBuster,
    isAuthed,
    setToken,
    setUser,
    bumpAvatarBuster,
    logout,
    fetchProfile,
  }
})
