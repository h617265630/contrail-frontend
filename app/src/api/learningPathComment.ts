import request from '../utils/request'

export interface LearningPathComment {
  id: number
  learning_path_id: number
  user_id: number
  username: string
  content: string
  created_at: string
}

export interface LearningPathCommentCreate {
  content: string
}

export function listLearningPathComments(learningPathId: string | number) {
  return request.get<LearningPathComment[], LearningPathComment[]>(`/learning-paths/${learningPathId}/comments`)
}

export function postLearningPathComment(learningPathId: string | number, content: string) {
  return request.post<LearningPathComment, LearningPathComment>(`/learning-paths/${learningPathId}/comments`, { content })
}
