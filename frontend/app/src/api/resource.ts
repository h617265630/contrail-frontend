import request from '../utils/request'

export interface UrlExtractResponse {
  title: string
  description?: string | null
  thumbnail_url?: string | null
  author?: string | null
  publish_date?: string | null
  video_id?: string | null
  chapters?: ChapterItem[]
}

export function extractVideoMetadata(url: string) {
  return request.post<UrlExtractResponse, UrlExtractResponse>('/resources/extract', { url })
}

export interface DbResource {
  id: number
  title: string
  description?: string | null
  resource_type: string

  is_public?: boolean
  url?: string | null
  source?: string | null
  // Legacy category string kept for backward compatibility.
  category?: string | null
  // New categories FK support.
  category_id?: number | null
  category_name?: string | null
  thumbnail_url?: string | null
  created_at?: string | null
}

export interface ChapterItem {
  start_seconds: number
  timestamp: string
  title: string
  description?: string | null
}

export interface DbResourceDetail extends DbResource {
  author?: string | null
  publish_date?: string | null
  video_id?: string | null
  chapters: ChapterItem[]
}

export function listMyResources() {
  return request.get<DbResource[], DbResource[]>('/resources/me')
}

export function listResources() {
  return request.get<DbResource[], DbResource[]>('/resources')
}

export function createMyResourceFromUrl(
  url: string,
  payload?: { category?: string; category_id?: number | null },
) {
  const body: Record<string, any> = { url }
  if (payload?.category) body.category = payload.category
  if (payload?.category_id !== undefined) body.category_id = payload.category_id
  return request.post<DbResource, DbResource>('/resources/me', body)
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

export function deleteMyResource(resourceId: number) {
  return request.delete(`/resources/me/${resourceId}`)
}

export function updateMyResource(
  resourceId: number,
  payload: { url?: string; title?: string; description?: string; is_public?: boolean },
) {
  return request.patch<DbResource, DbResource>(`/resources/me/${resourceId}`, payload)
}

export function getMyResourceDetail(resourceId: number) {
  return request.get<DbResourceDetail, DbResourceDetail>(`/resources/me/${resourceId}`)
}

export function getResourceDetail(resourceId: number) {
  return request.get<DbResourceDetail, DbResourceDetail>(`/resources/${resourceId}`)
}

export type ResolveResourceByUrlResponse = { id: number }

export function resolvePublicResourceIdByUrl(url: string) {
  return request.get<ResolveResourceByUrlResponse, ResolveResourceByUrlResponse>('/resources/resolve', {
    params: { url },
  })
}
