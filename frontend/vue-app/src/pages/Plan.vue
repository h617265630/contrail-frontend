<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-5xl mx-auto space-y-8">
    <header class="space-y-2">
      <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">Plans</p>
      <h1 class="text-3xl font-bold text-gray-900">选择适合你的方案</h1>
      <p class="text-gray-600">免费起步，进阶方案支持月付与年付（年付 8 折）。</p>
    </header>

    <div class="grid gap-4 md:grid-cols-3">
      <article
        v-for="plan in plans"
        :key="plan.id"
        class="rounded-2xl bg-white shadow-lg p-6 flex flex-col gap-4 h-full"
        :class="plan.highlight ? 'ring-1 ring-blue-200' : ''"
      >
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900">{{ plan.name }}</h2>
            <p class="text-gray-600 text-sm">{{ plan.description }}</p>
          </div>
          <span v-if="plan.highlight" class="px-3 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">推荐</span>
        </div>

        <div class="grid gap-3 md:grid-cols-2">
          <div class="rounded-lg bg-gray-50 shadow-sm p-4">
            <p class="text-sm text-gray-600">月付</p>
            <div class="text-2xl font-bold text-gray-900 mt-1">{{ plan.monthly }}</div>
          </div>
          <div class="rounded-lg bg-blue-50 shadow-sm p-4">
            <p class="text-sm text-gray-700">年付（8 折）</p>
            <div class="text-xl font-bold text-blue-700 mt-1">{{ plan.yearly }} <span class="text-sm text-blue-600">≈ {{ plan.yearlyMonthly }} /月</span></div>
          </div>
        </div>

        <div class="space-y-2 flex-1">
          <p class="text-sm font-semibold text-gray-800">包含功能：</p>
          <ul class="space-y-1 text-sm text-gray-700 list-disc list-inside">
            <li v-for="feat in plan.features" :key="feat">{{ feat }}</li>
          </ul>
        </div>

        <button
          class="w-full md:w-auto px-4 py-2 rounded-full bg-white border border-gray-200 shadow-sm text-gray-700 text-sm font-semibold hover:bg-gray-50 hover:border-gray-300 transition-colors"
        >
          选择 {{ plan.name }}
        </button>
      </article>
    </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

type Plan = {
  id: string
  name: string
  description: string
  monthly: string
  yearly: string
  yearlyMonthly: string
  features: string[]
  highlight?: boolean
}

const basePlans: Array<Omit<Plan, 'yearly' | 'yearlyMonthly'>> = [
  {
    id: 'free',
    name: '免费版',
    description: '适合入门与个人学习。',
    monthly: '¥0 /月',
    features: ['基础学习路径预览', '公开资源访问', '笔记本地编辑'],
  },
  {
    id: 'basic',
    name: '基础版',
    description: '适合常规进阶与小型团队。',
    monthly: '¥29 /月',
    features: ['全部学习路径', '资源库增删改', '云端笔记同步', '进度跟踪与导出'],
  },
  {
    id: 'pro',
    name: '高级版',
    description: '适合重度使用与专业团队。',
    monthly: '¥59 /月',
    features: ['团队协作与共享', '自定义路径与模板', '高级搜索与过滤', '优先支持与SLA'],
    highlight: true,
  },
]

const plans = computed<Plan[]>(() => {
  return basePlans.map((p) => {
    const monthlyNumber = Number(p.monthly.replace(/[^0-9.]/g, '')) || 0
    const yearlyNumber = monthlyNumber * 12 * 0.8
    const yearly = monthlyNumber === 0 ? '¥0 /年' : `¥${yearlyNumber.toFixed(0)} /年`
    const yearlyMonthly = monthlyNumber === 0 ? '¥0' : `¥${(yearlyNumber / 12).toFixed(1)}`
    return {
      ...p,
      yearly,
      yearlyMonthly,
    }
  })
})
</script>
