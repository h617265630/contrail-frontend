import request from '../utils/request'

export type UserImage = {
  id: number
  user_id: number
  title?: string | null
  image_url: string
  created_at: string
}

export function listMyUserImages() {
  return request.get<UserImage[], UserImage[]>('/user-images/me')
}
