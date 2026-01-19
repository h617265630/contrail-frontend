<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-5xl mx-auto space-y-8">
    <header class="space-y-2">
      <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">Plans</p>
      <h1 class="text-3xl font-bold text-gray-900">选择适合你的方案</h1>
      <p class="text-gray-600">使用 Contrail 的核心能力，开始结构化你的学习。</p>
      <div class="inline-flex items-center gap-2 rounded-full bg-white border border-gray-200 px-3 py-1 text-sm text-gray-700">
        <span class="font-semibold">当前方案：</span>
        <span class="font-bold text-gray-900">{{ currentPlan }}</span>
      </div>
    </header>

    <div class="grid gap-4 md:grid-cols-3">
      <article
        v-for="plan in plans"
        :key="plan.id"
        class="rounded-2xl bg-white shadow-lg p-6 flex flex-col gap-4 h-full"
        :class="[plan.highlight ? 'ring-1 ring-blue-200' : '', isCurrent(plan) ? 'ring-2 ring-blue-400' : '']"
      >
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900">{{ plan.name }}</h2>
            <p class="text-gray-600 text-sm">{{ plan.description }}</p>
          </div>
          <span v-if="plan.highlight" class="px-3 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">推荐</span>
        </div>

        <div class="space-y-2 flex-1">
          <p class="text-sm font-semibold text-gray-800">适合：</p>
          <p class="text-sm text-gray-700">{{ plan.suitable }}</p>

          <p class="text-sm font-semibold text-gray-800 mt-2">包含：</p>
          <ul class="space-y-1 text-sm text-gray-700 list-disc list-inside">
            <li v-for="feat in plan.features" :key="feat">{{ feat }}</li>
          </ul>

          <p v-if="plan.tagline" class="text-sm text-gray-600 mt-2">{{ plan.tagline }}</p>
        </div>

        <button
          class="w-full md:w-auto px-4 py-2 rounded-full bg-white border border-gray-200 shadow-sm text-gray-700 text-sm font-semibold hover:bg-gray-50 hover:border-gray-300 transition-colors"
          type="button"
          @click="onSelectPlan(plan)"
        >
          {{ isCurrent(plan) ? '当前方案' : plan.cta }}
        </button>
      </article>
    </div>

    <section class="bg-white rounded-2xl shadow-lg p-6">
      <h2 class="text-lg font-semibold text-gray-900 mb-3">对比说明</h2>
      <ul class="space-y-1 text-sm text-gray-700 list-disc list-inside">
        <li>所有方案均支持进度记录</li>
        <li>你可以随时升级或降级方案</li>
        <li>你的学习数据始终属于你</li>
      </ul>
    </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { getPlanInfo, selectPlan as persistSelectPlan, type PlanName } from '../utils/plan'

type Plan = {
  id: string
  name: PlanName
  description: string
  suitable: string
  features: string[]
  tagline?: string
  cta: string
  highlight?: boolean
}

const plans = computed<Plan[]>(() => [
  {
    id: 'free',
    name: 'Free',
    description: '适合刚开始构建学习路径、轻度学习用户',
    suitable: '刚开始构建学习路径、轻度学习用户',
    features: ['查看所有公开资源', '查看所有公开 Learning Path', '创建最多 5 条 Learning Path', '随时查看自己的学习进度'],
    tagline: '使用 Contrail 的核心能力，开始结构化你的学习。',
    cta: '立即开始',
  },
  {
    id: 'basic',
    name: 'Basic',
    description: '适合有明确学习目标、需要更多个人管理空间的用户',
    suitable: '有明确学习目标、需要更多个人管理空间的用户',
    features: ['创建最多 10 条 Learning Path', '随时查看完整学习进度', '创建最多 5 条私有 Learning Path', '更灵活地管理你的学习结构'],
    tagline: '在公开与私有之间取得平衡，专注推进自己的学习计划。',
    cta: '升级以解锁更多路径',
  },
  {
    id: 'pro',
    name: 'Pro',
    description: '适合长期学习者、重度学习用户、内容创作者',
    suitable: '长期学习者、重度学习用户、内容创作者',
    features: ['创建无限条 Learning Path', '使用 AI 生成学习笔记与总结', 'AI 分析学习章节与内容结构', '基于 AI 的资源与 Learning Path 分析与优化建议'],
    tagline: '让 AI 成为你的学习助手，持续优化你的学习路径与学习效率。',
    cta: '使用 AI 深度优化你的学习',
    highlight: true,
  },
])

const currentPlan = ref<PlanName>(getPlanInfo().name as PlanName)

function isCurrent(plan: Plan) {
  return currentPlan.value === plan.name
}

function onSelectPlan(plan: Plan) {
  const name = plan.name as PlanName
  currentPlan.value = name
  persistSelectPlan(name)
}
</script>
