import request from '../utils/request'

export type Category = {
  id: number
  name: string
  code: string
  description?: string | null
}

export function listCategories() {
  return request.get<Category[], Category[]>('/categories/')
}
