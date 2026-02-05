import request from '../utils/request'

export type UserFile = {
  id: number
  user_id: number
  title?: string | null
  file_type: 'md' | 'txt' | string
  original_filename?: string | null
  content_type?: string | null
  size_bytes?: number | null
  content?: string | null
  file_url: string
  created_at: string
}

export function listMyUserFiles() {
  return request.get<UserFile[], UserFile[]>('/user-files/me')
}

export function uploadMyUserFile(params: { file: File; title?: string; fileType?: 'md' | 'txt' }) {
  const fd = new FormData()
  fd.append('file', params.file)
  if (params.title) fd.append('title', params.title)
  return request.post<UserFile, UserFile>('/user-files/me/upload', fd)
}

export function fetchUserFileText(fileUrl: string) {
  return (request as any).get(fileUrl, { responseType: 'text' }) as Promise<string>
}
