import request from '../utils/request'

export type EffectivePlan = 'Free' | 'Basic' | 'Pro'

export interface SubscriptionMeResponse {
  effective_plan: EffectivePlan
  plan_code?: string | null
  status?: string | null
  current_period_start?: string | null
  current_period_end?: string | null
  cancel_at_period_end?: boolean | null
}

export function getMySubscription() {
  return request.get('/subscriptions/me') as Promise<SubscriptionMeResponse>
}

export function devSeedMySubscription(payload: { plan_code: string }) {
  return request.post('/subscriptions/dev/seed', payload) as Promise<SubscriptionMeResponse>
}
