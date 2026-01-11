<template>
	<div class="max-w-7xl mx-auto space-y-10">
		<!-- Banner -->
		<section class="relative overflow-hidden rounded-2xl text-white shadow-xl">
			<img
				aria-hidden="true"
				src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=1600&h=900&fit=crop"
				alt=""
				class="absolute inset-0 h-full w-full object-cover"
			/>
			<div class="absolute inset-0 bg-black/35" aria-hidden="true" />
			<div class="relative px-8 py-10 md:px-12 md:py-14 flex flex-col md:flex-row md:items-center md:justify-between gap-6">
				<div class="space-y-4 max-w-xl">
					<p class="text-sm uppercase tracking-wide text-white/80">精选路径</p>
					<h1 class="text-3xl md:text-4xl font-bold leading-tight">开启你的学习旅程</h1>
					<p class="text-white/90">从基础到进阶，精选路径帮你快速上手并构建体系化能力。</p>
					<p class="text-white-200 italic text-xs tracking-wide">
						请先阅读
						<RouterLink to="/about" class="mx-1 font-semibold text-red-300 underline underline-offset-4 hover:text-yellow-50">
							about
						</RouterLink>
						页面查看相关功能介绍
					</p>
					<div class="flex flex-wrap gap-3">
						<RouterLink
							to="/learningpool"
							class="inline-flex items-center gap-2 rounded-lg bg-white text-blue-700 px-4 py-2 text-sm font-semibold shadow hover:bg-blue-50"
						>
							立即开始
							<span aria-hidden>→</span>
						</RouterLink>
						<RouterLink
							to="/mypaths"
							class="inline-flex items-center gap-2 rounded-lg border border-white/30 text-white px-4 py-2 text-sm font-semibold hover:bg-white/10"
						>
							查看全部路径
						</RouterLink>
						<RouterLink
							to="/createpath"
							class="inline-flex items-center gap-2 rounded-lg bg-pink-600 text-white px-4 py-2 text-sm font-semibold shadow hover:bg-pink-700"
						>
							创建路径
						</RouterLink>
					</div>
				</div>
				<div class="hidden md:block w-64 h-40 rounded-xl bg-white/10 backdrop-blur border border-white/20" aria-hidden>
					<div class="h-full w-full flex items-center justify-center text-white/70 text-sm">
						Banner Illustration
					</div>
				</div>
			</div>
		</section>

		<!-- 常用 Learning Path 卡片（单行 5 个） -->
		<section class="space-y-4">
			<div class="flex items-center justify-between">
				<div>
					<h2 class="text-xl font-semibold text-gray-900">常用学习路径</h2>
					<p class="text-gray-600 text-sm">为你挑选的 5 条热门路径</p>
				</div>
				<RouterLink to="/mypaths" class="text-blue-600 hover:text-blue-700 text-sm font-medium">查看全部</RouterLink>
			</div>
			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
				<RouterLink
					v-for="path in featuredPaths"
					:key="path.id"
					:to="{ name: 'learningpath', params: { id: path.id } }"
					class="block"
				>
					<Card as="article" :hoverable="true">
						<div class="relative h-28 bg-gray-100">
							<img :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover" />
						</div>
						<div class="p-4 flex flex-col gap-3">
							<div class="space-y-1">
								<h3 class="text-gray-900 font-semibold text-sm leading-snug line-clamp-2" :title="path.title">{{ path.title }}</h3>
								<p class="text-gray-600 text-xs line-clamp-2" :title="path.description">{{ path.description }}</p>
							</div>
							<div class="flex items-center justify-between text-xs text-gray-500">
								<span>{{ path.level }}</span>
								<span>{{ path.duration }}</span>
							</div>
						</div>
					</Card>
				</RouterLink>
			</div>
		</section>

		<!-- LearningPool 随机推荐（瀑布流，按断点变化列数） -->
		<section class="space-y-4">
			<div class="flex items-center justify-between">
				<div>
					<h2 class="text-xl font-semibold text-gray-900">LearningPool 随机推荐</h2>
					<p class="text-gray-600 text-sm">瀑布流展示（大屏每行 6 个）</p>
				</div>
				<RouterLink to="/learningpool" class="text-blue-600 hover:text-blue-700 text-sm font-medium">去 LearningPool</RouterLink>
			</div>
			<div class="columns-1 sm:columns-2 md:columns-3 lg:columns-6 gap-4">
				<RouterLink
					v-for="(path, idx) in randomPoolPaths"
					:key="`${path.id}-${idx}`"
					:to="{ name: 'learningpath', params: { id: path.id } }"
					class="block mb-4 break-inside-avoid"
				>
					<Card as="article" :hoverable="true">
						<div :class="['relative bg-gray-100', randomCoverHeightClass(idx)]">
							<img :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover" />
						</div>
						<div class="p-4 flex flex-col gap-3">
							<div class="space-y-1">
								<h3 class="text-gray-900 font-semibold text-sm leading-snug line-clamp-2" :title="path.title">{{ path.title }}</h3>
								<p class="text-gray-600 text-xs line-clamp-2" :title="path.description">{{ path.description }}</p>
							</div>
							<div class="flex items-center justify-between text-xs text-gray-500">
								<span>{{ path.level }}</span>
								<span>{{ path.duration }}</span>
							</div>
						</div>
					</Card>
				</RouterLink>
			</div>
		</section>
	</div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { RouterLink } from 'vue-router'
import { learningPoolPaths } from '../data/learningPool'
import Card from '../components/ui/Card.vue'

const coverHeightVariants = ['h-24', 'h-28', 'h-32', 'h-40', 'h-48'] as const

function randomCoverHeightClass(idx: number) {
	return coverHeightVariants[idx % coverHeightVariants.length]
}

interface FeaturedPath {
	id: string
	title: string
	description: string
	thumbnail: string
	level: string
	duration: string
}

const featuredPaths = ref<FeaturedPath[]>([
	{
		id: 'lp-1',
		title: 'Full Stack Web Development',
		description: 'React/Vue、Node、数据库与部署的端到端实战',
		thumbnail: 'https://images.unsplash.com/photo-1523475472560-d2df97ec485c?w=400&h=240&fit=crop',
		level: '进阶',
		duration: '24h',
	},
	{
		id: 'lp-2',
		title: 'Frontend Mastery',
		description: 'UI/UX、组件化、性能优化与设计体系',
		thumbnail: 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400&h=240&fit=crop',
		level: '中级',
		duration: '18h',
	},
	{
		id: 'lp-3',
		title: 'AI 工程师入门',
		description: '机器学习、深度学习与大模型基础到落地',
		thumbnail: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=240&fit=crop',
		level: '中级',
		duration: '20h',
	},
	{
		id: 'lp-4',
		title: 'DevOps 基础',
		description: 'CI/CD、容器化、K8s 与可观测性入门',
		thumbnail: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=240&fit=crop',
		level: '初级',
		duration: '16h',
	},
	{
		id: 'lp-5',
		title: '数据与可视化',
		description: '数据分析、SQL、可视化与仪表盘搭建',
		thumbnail: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400&h=240&fit=crop',
		level: '初级',
		duration: '14h',
	},
])

function pickRandom<T>(items: T[], count: number) {
	const arr = [...items]
	for (let i = arr.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1))
		;[arr[i], arr[j]] = [arr[j], arr[i]]
	}
	return arr.slice(0, Math.min(count, arr.length))
}

function pickRandomWithReplacement<T>(items: T[], count: number) {
	if (items.length === 0) return [] as T[]
	const out: T[] = []
	for (let i = 0; i < count; i++) {
		out.push(items[Math.floor(Math.random() * items.length)])
	}
	return out
}

const randomPoolPaths = computed<FeaturedPath[]>(() => {
	const picks = pickRandomWithReplacement(learningPoolPaths, 24)
	return picks.map(p => ({
		id: p.id,
		title: p.title,
		description: p.description,
		thumbnail: p.thumbnail,
		level: p.level,
		duration: `${p.items} items`,
	}))
})
</script>
