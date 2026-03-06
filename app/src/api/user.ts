import request from '../utils/request'

export interface UserProfile {
  id: number
  username: string
  email: string
  display_name?: string | null
  avatar_url?: string | null
  bio?: string | null
  is_active?: boolean
  is_superuser?: boolean
}

export function getCurrentUser() {
  return request.get('/users/me') as Promise<UserProfile>
}

export function updateCurrentUser(payload: { display_name?: string | null; avatar_url?: string | null; bio?: string | null }) {
  return request.patch('/users/me', payload) as Promise<UserProfile>
}

export function uploadMyAvatar(file: File) {
  const form = new FormData()
  form.append('file', file)
  return request.post('/users/me/avatar', form) as Promise<{ avatar_url: string }>
}

export function changeMyPassword(payload: { current_password: string; new_password: string }) {
  return request.post('/users/me/password', payload)
}
