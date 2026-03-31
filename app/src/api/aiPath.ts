import request from '../utils/request'

export interface AiPathResourceLink {
  url: string
}

export interface AiPathSubNode {
  title: string
  description: string
  resources?: AiPathResourceLink[]
}

export interface AiPathNode {
  title: string
  description: string
  explanation?: string
  tutorial?: string[]
  resources?: AiPathResourceLink[]
  sub_nodes?: AiPathSubNode[]
  order?: number
}

export interface AiPathData {
  title: string
  summary: string
  nodes: AiPathNode[]
}

export interface AiPathGenerateResponse {
  data: AiPathData
  warnings: string[]
}

export function generateAiPath(query: string) {
  return request.post<AiPathGenerateResponse, AiPathGenerateResponse>('/ai-path/generate', { query })
}
