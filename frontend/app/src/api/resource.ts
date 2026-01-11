import request from '../utils/request'

export interface UrlExtractResponse {
  title: string
  description?: string | null
}

export function extractVideoMetadata(url: string) {
  return request.post<UrlExtractResponse, UrlExtractResponse>('/resources/extract', { url })
}

export interface DbResource {
  id: number
  title: string
  description?: string | null
  resource_type: string
  url?: string | null
  source?: string | null
  category?: string | null
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

export function createMyResourceFromUrl(url: string, category?: string) {
  return request.post<DbResource, DbResource>('/resources/me', { url, category })
}

export function deleteMyResource(resourceId: number) {
  return request.delete(`/resources/me/${resourceId}`)
}

export function getMyResourceDetail(resourceId: number) {
  return request.get<DbResourceDetail, DbResourceDetail>(`/resources/me/${resourceId}`)
}
