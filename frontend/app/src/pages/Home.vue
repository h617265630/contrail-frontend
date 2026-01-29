<template>
	<div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
		<!-- Banner -->
		<section class="relative overflow-hidden text-white shadow-xl">
			<img
				aria-hidden="true"
				src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=1600&h=900&fit=crop"
				alt=""
				class="absolute inset-0 h-full w-full object-cover"
			/>
			<div class="absolute inset-0 bg-black/35" aria-hidden="true" />
			<div class="relative px-8 py-10 md:px-12 md:py-14 flex flex-col md:flex-row md:items-center md:justify-between gap-6">
				<div class="space-y-4 max-w-xl">
					<p class="text-sm uppercase tracking-wide text-white/80">{{ t('Contrail') }}</p>
					<h1 class="text-3xl md:text-4xl font-bold leading-tight">{{ t('Build system-level skills with structured learning paths') }}</h1>
					<p class="text-white/90">{{ t('This is a Learning Path Platform: create and discover great learning paths, turn scattered knowledge into an actionable plan, and track progress as you improve over time.') }}</p>
					<p class="text-white-200 italic text-xs tracking-wide">
						Read
						<RouterLink to="/about" class="mx-1 font-semibold text-red-300 underline underline-offset-4 hover:text-yellow-50">
							About
						</RouterLink>
						for a quick overview.
					</p>
					<div class="flex flex-wrap gap-3">
						<Button
							:as="RouterLinkComp"
							to="/learningpool"
							variant="default"
							size="sm"
							class="rounded-lg bg-white text-blue-700 hover:bg-blue-50"
						>
							Start now
							<span aria-hidden>→</span>
						</Button>
						<Button
							:as="RouterLinkComp"
							to="/my-paths"
							variant="outline"
							size="sm"
							class="rounded-lg border-white/30 text-white hover:bg-white/10 hover:text-white"
						>
							View all paths
						</Button>
						<Button
							:as="RouterLinkComp"
							to="/createpath"
							variant="default"
							size="sm"
							class="rounded-lg bg-pink-600 text-white hover:bg-pink-700"
						>
							Create path
						</Button>
					</div>
				</div>
				<div class="hidden md:block w-64 h-40 bg-white/10 backdrop-blur border border-white/20" aria-hidden>
					<div class="h-full w-full flex items-center justify-center text-white/70 text-sm">
						Banner Illustration
					</div>
				</div>
			</div>
		</section>

		<section class="border-b border-border pb-8">
			<div class="grid gap-6 md:grid-cols-12 md:items-end">
				<div class="md:col-span-8">
					<p class="text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground">{{ t('Contrail') }}</p>
					<h1 class="mt-3 text-3xl font-semibold tracking-tight text-foreground md:text-4xl">
						{{ t('Build system-level skills with structured learning paths') }}
					</h1>
					<p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">
						{{ t('This is a Learning Path Platform: create and discover great learning paths, turn scattered knowledge into an actionable plan, and track progress as you improve over time.') }}
					</p>
					<p class="mt-3 text-xs text-muted-foreground">
						Read
						<RouterLink to="/about" class="mx-1 underline underline-offset-4 hover:text-foreground">
							About
						</RouterLink>
						for a quick overview.
					</p>
				</div>
				<div class="md:col-span-4 md:flex md:justify-end">
					<div class="flex flex-wrap gap-2">
						<Button
							:as="RouterLinkComp"
							to="/learningpool"
							variant="default"
							size="sm"
							class="rounded-none"
						>
							Start now
						</Button>
						<Button
							:as="RouterLinkComp"
							to="/my-paths"
							variant="outline"
							size="sm"
							class="rounded-none"
						>
							View all paths
						</Button>
						<Button
							:as="RouterLinkComp"
							to="/createpath"
							variant="outline"
							size="sm"
							class="rounded-none bg-foreground text-background hover:bg-foreground/90 hover:text-background"
						>
							Create path
						</Button>
					</div>
				</div>
			</div>
		</section>

		<!-- Featured paths -->
		<section class="space-y-4">
			<div class="flex items-center justify-between">
				<div>
					<h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Featured Learning Paths</h2>
					<p class="text-sm text-muted-foreground">5 popular paths to get started</p>
				</div>
				<Button
					:as="RouterLinkComp"
					to="/my-paths"
					variant="ghost"
					size="sm"
					class="rounded-none px-0 hover:bg-transparent"
				>
					View all
				</Button>
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

		<!-- LearningPool picks -->
		<section class="space-y-4">
			<div class="flex items-center justify-between">
				<div>
					<h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">LearningPool Picks</h2>
					<p class="text-sm text-muted-foreground">Masonry layout (up to 6 columns on large screens)</p>
				</div>
				<Button
					:as="RouterLinkComp"
					to="/learningpool"
					variant="ghost"
					size="sm"
					class="rounded-none px-0 hover:bg-transparent"
				>
					Open LearningPool
				</Button>
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
import { computed, ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'
import { useI18n } from '../i18n'
import { listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'

const RouterLinkComp = RouterLink

const { t } = useI18n()

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

const featuredPaths = ref<FeaturedPath[]>([])

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

const randomPoolPaths = ref<FeaturedPath[]>([])

onMounted(async () => {
	try {
		const db = await listPublicLearningPaths()
		// 取前5个作为 featuredPaths
		featuredPaths.value = db.slice(0, 5).map((p) => ({
			id: String(p.id),
			title: p.title,
			description: p.description || '',
			thumbnail: p.cover_image_url || '',
			level: 'Beginner',
			duration: '',
		}))
		// 随机取24个作为 randomPoolPaths
		const picks = pickRandomWithReplacement(db, 24)
		randomPoolPaths.value = picks.map((p) => ({
			id: String(p.id),
			title: p.title,
			description: p.description || '',
			thumbnail: p.cover_image_url || '',
			level: 'Beginner',
			duration: '',
		}))
	} catch {
		featuredPaths.value = []
		randomPoolPaths.value = []
	}
})
</script>
