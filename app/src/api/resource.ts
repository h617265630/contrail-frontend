import request from '../utils/request'

export interface UrlExtractResponse {
  title: string
  description?: string | null
  thumbnail_url?: string | null
  author?: string | null
  publish_date?: string | null
  video_id?: string | null
  duration_seconds?: number | null
  platform?: string | null
  chapters?: ChapterItem[]
}

export function extractVideoMetadata(url: string) {
  return request.post<UrlExtractResponse, UrlExtractResponse>('/resources/extract', { url })
}

export interface DbResource {
  id: number
  resource_type: string
  platform: string
  title: string
  summary: string | null
  source_url: string
  thumbnail: string | null
  category_id: number | null
  difficulty: string | null
  tags: object
  created_at: string
  updated_at: string
  category_name?: string
  is_system_public?: boolean

  manual_weight?: number | null
  behavior_weight?: number | null
  effective_weight?: number | null
  added_at?: string | null
  last_opened?: string | null
  open_count?: number | null
  completion_status?: boolean | null

  community_score?: number | null
  save_count?: number | null
  trending_score?: number | null
  user_seq?: number | null
}

// 添加资源的请求参数
export interface CreateResourceRequest {
  url: string
  category_id: number
  is_system_public: boolean
}

// 添加资源的响应
export interface CreateResourceResponse {
  resource: DbResource
}

// 添加资源


export interface ChapterItem {
  start_seconds: number
  timestamp: string
  title: string
  description?: string | null
}

export interface DbResourceDetail extends DbResource {
  video?: {
    duration?: number | null
    channel?: string | null
    video_id?: string | null
  } | null
  doc?: {
    doc_type?: string | null
    version?: string | null
  } | null
  article?: {
    publisher?: string | null
    published_at?: string | null
  } | null
}

export function listMyResources() {
  return request.get<DbResource[], DbResource[]>('/resources/me')
}

export function listResources() {
  return request.get<DbResource[], DbResource[]>('/resources')
}

export function createMyResourceFromUrl(
  url: string,
  payload?: { category_id: number; is_public?: boolean; manual_weight?: number },
) {
  return request.post<DbResource, DbResource>('/resources/me', { url, ...(payload || {}) })
}

export function addPublicResourceToMyResources(resourceId: number) {
  return request.post<DbResource, DbResource>(`/resources/me/${resourceId}`, {})
}

export type AddToMyResourcesResult = {
  already_exists: boolean
  resource: DbResource
}

export function addPublicResourceToMyResourcesWithStatus(resourceId: number) {
  return request.post<AddToMyResourcesResult, AddToMyResourcesResult>(`/resources/me/${resourceId}/attach`, {})
}

export function addPublicResourceToMyResourcesWithStatusAndWeight(resourceId: number, payload?: { manual_weight?: number }) {
  return request.post<AddToMyResourcesResult, AddToMyResourcesResult>(`/resources/me/${resourceId}/attach`, payload || {})
}

export function deleteMyResource(resourceId: number) {
  return request.delete(`/resources/me/${resourceId}`)
}

export function deleteResource(resourceId: number) {
  return request.delete(`/resources/${resourceId}`)
}

export function updateMyResource(
  resourceId: number,
  payload: {
    title?: string
    summary?: string | null
    platform?: string | null
    thumbnail?: string | null
    difficulty?: number | null
    tags?: Record<string, any> | null
    raw_meta?: Record<string, any> | null
    manual_weight?: number | null
  },
) {
  return request.patch<DbResource, DbResource>(`/resources/me/${resourceId}`, payload)
}

export function getMyResourceDetail(resourceId: number) {
  return request.get<DbResourceDetail, DbResourceDetail>(`/resources/me/${resourceId}`)
}

export function getResourceDetail(resourceId: number) {
  return request.get<DbResourceDetail, DbResourceDetail>(`/resources/${resourceId}`)
}