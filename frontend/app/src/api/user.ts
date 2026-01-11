import request from '../utils/request'

export interface UserProfile {
  id: number
  username: string
  email: string
  is_active?: boolean
  is_superuser?: boolean
}

export function getCurrentUser() {
  return request.get('/users/me') as Promise<UserProfile>
}
