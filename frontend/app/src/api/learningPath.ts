import request from '../utils/request'
import type { DbResourceDetail } from './resource'

export type PublicLearningPath = {
  id: number
  title: string
  description?: string | null
  is_public: boolean
  is_active: boolean
  category_id?: number | null
  category_name?: string | null
}

export type PublicLearningPathDetail = PublicLearningPath & {
  path_items: Array<{
    id: number
    learning_path_id: number
    resource_id: number
    resource_type: string
    title: string
    position: number
    description?: string | null
    resource_data?: DbResourceDetail | null
  }>
}

export function listPublicLearningPaths() {
  return request.get<PublicLearningPath[], PublicLearningPath[]>('/learning-paths/public')
}

export function getPublicLearningPathDetail(id: number) {
  return request.get<PublicLearningPathDetail, PublicLearningPathDetail>(`/learning-paths/public/${id}`)
}

export function createLearningPath(payload: { title: string; description?: string; is_public: boolean }) {
  return request.post<PublicLearningPath, PublicLearningPath>('/learning-paths/', payload)
}

export function createLearningPathWithCategory(payload: {
  title: string
  description?: string
  is_public: boolean
  category_id?: number | null
}) {
  return request.post<PublicLearningPath, PublicLearningPath>('/learning-paths/', payload)
}

export type MyLearningPath = PublicLearningPath

export type MyLearningPathDetail = PublicLearningPathDetail

export function listMyLearningPaths() {
  return request.get<MyLearningPath[], MyLearningPath[]>('/learning-paths/')
}

export function getMyLearningPathDetail(id: number) {
  return request.get<MyLearningPathDetail, MyLearningPathDetail>(`/learning-paths/${id}`)
}

export function updateMyLearningPath(
  id: number,
  payload: { title?: string; description?: string; is_public?: boolean; category_id?: number | null },
) {
  return request.patch<MyLearningPath, MyLearningPath>(`/learning-paths/${id}`, payload)
}

export type AttachLearningPathResult = {
  already_exists: boolean
  learning_path: MyLearningPath
}

export function attachPublicLearningPathToMe(id: number) {
  return request.post<AttachLearningPathResult, AttachLearningPathResult>(`/learning-paths/me/${id}/attach`, {})
}

export function deleteMyLearningPath(id: number) {
  return request.delete(`/learning-paths/${id}`)
}

export function addResourceToMyLearningPath(
  learningPathId: number,
  payload: {
    resource_type: 'video' | 'clip' | 'link'
    resource_id: number
    title?: string
    description?: string
    position?: number
  },
) {
  return request.post(`/learning-paths/${learningPathId}/items`, payload)
}
