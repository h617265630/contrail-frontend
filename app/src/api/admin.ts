import request from '../utils/request'

// Types
export interface AdminStats {
  total_users: number
  active_users: number
  total_learning_paths: number
  public_learning_paths: number
  total_resources: number
  total_categories: number
  users_last_7_days: number
  paths_last_7_days: number
  resources_last_7_days: number
}

export interface AdminUser {
  id: number
  username: string
  email: string
  display_name?: string | null
  is_active: boolean
  is_superuser: boolean
  created_at: string
  roles: string[]
}

export interface AdminUserListResponse {
  users: AdminUser[]
  total: number
  skip: number
  limit: number
}

export interface AdminLearningPath {
  id: number
  title: string
  is_public: boolean
  is_active: boolean
  category_name?: string | null
  created_at: string
  user_count: number
}

export interface AdminLearningPathListResponse {
  paths: AdminLearningPath[]
  total: number
}

export interface AdminResource {
  id: number
  title: string
  resource_type: string
  platform?: string | null
  category_name?: string | null
  save_count: number
  trending_score: number
  created_at: string
}

export interface AdminResourceListResponse {
  resources: AdminResource[]
  total: number
}

export interface DailyCountItem {
  date: string
  count: number
}

export interface CategoryCountItem {
  name: string
  count: number
}

export interface TopResourceItem {
  title: string
  save_count: number
}

export interface AdminAnalytics {
  daily_users: DailyCountItem[]
  daily_paths: DailyCountItem[]
  daily_resources: DailyCountItem[]
  top_categories: CategoryCountItem[]
  top_resources: TopResourceItem[]
}

// API Functions
export function getAdminStats() {
  return request.get<AdminStats, AdminStats>('/admin/stats')
}

export function getAdminUsers(params: {
  skip?: number
  limit?: number
  search?: string
  is_active?: boolean
  is_superuser?: boolean
}) {
  return request.get<AdminUserListResponse, AdminUserListResponse>('/admin/users', { params })
}

export function toggleUserStatus(userId: number) {
  return request.patch<{ message: string; is_active: boolean }, any>(`/admin/users/${userId}/toggle-status`)
}

export function toggleSuperuserStatus(userId: number) {
  return request.patch<{ message: string; is_superuser: boolean }, any>(`/admin/users/${userId}/toggle-superuser`)
}

export function getAdminLearningPaths(params?: { skip?: number; limit?: number }) {
  return request.get<AdminLearningPathListResponse, AdminLearningPathListResponse>('/admin/learning-paths', { params })
}

export function deleteAdminLearningPath(pathId: number) {
  return request.delete<{ message: string }, any>(`/admin/learning-paths/${pathId}`)
}

export function getAdminResources(params?: { skip?: number; limit?: number }) {
  return request.get<AdminResourceListResponse, AdminResourceListResponse>('/admin/resources', { params })
}

export function deleteAdminResource(resourceId: number) {
  return request.delete<{ message: string }, any>(`/admin/resources/${resourceId}`)
}

export function getAdminAnalytics(days?: number) {
  return request.get<AdminAnalytics, AdminAnalytics>('/admin/analytics', { params: { days } })
}
