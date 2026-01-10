import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import type { UserProfile } from '../api/user'
import { getCurrentUser } from '../api/user'

// 轻量登录态：存 token + 用户信息，保证 NavBar 等任意组件都能读取共享状态
// 使用 globalThis.localStorage，避免在 TS 没有 DOM lib 时编译报错
const TOKEN_KEY = 'learnsmart_token'
const USER_KEY = 'learnsmart_user'

function readToken(): string | null {
  try {
    const storage = (globalThis as any).localStorage
    return storage?.getItem(TOKEN_KEY) || null
  } catch {
    return null
  }
}

function readUser(): UserProfile | null {
  try {
    const storage = (globalThis as any).localStorage
    const raw = storage?.getItem(USER_KEY)
    return raw ? (JSON.parse(raw) as UserProfile) : null
  } catch {
    return null
  }
}

function persistToken(next: string | null) {
  try {
    const storage = (globalThis as any).localStorage
    if (next) {
      storage?.setItem(TOKEN_KEY, next)
    } else {
      storage?.removeItem(TOKEN_KEY)
    }
  } catch {
    // ignore storage errors
  }
}

function persistUser(next: UserProfile | null) {
  try {
    const storage = (globalThis as any).localStorage
    if (next) {
      storage?.setItem(USER_KEY, JSON.stringify(next))
    } else {
      storage?.removeItem(USER_KEY)
    }
  } catch {
    // ignore storage errors
  }
}

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(readToken())
  const user = ref<UserProfile | null>(readUser())
  const isAuthed = computed(() => !!token.value)

  function setToken(next: string | null) {
    token.value = next
    persistToken(next)
  }

  function setUser(next: UserProfile | null) {
    user.value = next
    persistUser(next)
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
    isAuthed,
    setToken,
    setUser,
    logout,
    fetchProfile,
  }
})
