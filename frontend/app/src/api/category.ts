import request from '../utils/request'

export type Category = {
  id: number
  name: string
  code: string
  description?: string | null
  is_system: boolean
}

export function listCategories() {
  return request.get<Category[], Category[]>('/categories/')
}

export function createCategory(payload: { name: string; code?: string; description?: string | null }) {
  return request.post<Category, Category>('/categories/', payload)
}
