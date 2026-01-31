<template>
	<div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
		<!-- Banner -->
		<section
			class="relative overflow-hidden text-white shadow-xl min-h-[320px] md:min-h-[360px]"
			@mouseenter="pauseCarousel"
			@mouseleave="resumeCarousel"
		>
			<img
				aria-hidden="true"
				:src="bannerSlides[activeBannerIndex].image"
				alt=""
				class="absolute inset-0 h-full w-full object-cover"
			/>
			<div class="absolute inset-0 bg-black/35" aria-hidden="true" />
			<div class="relative px-8 py-10 md:px-12 md:py-14 flex flex-col md:flex-row md:items-center md:justify-between gap-6 min-h-[320px] md:min-h-[360px]">
				<div class="space-y-4 max-w-xl">
					<template v-if="activeBannerIndex === 0">
						<h1 class="text-xl md:text-2xl font-bold leading-tight">{{ t('Build system-level skills with structured learning paths') }}</h1>
						<p class="text-white/90">{{ t('This is a Learning Path Platform: create and discover great learning paths, turn scattered knowledge into an actionable plan, and track progress as you improve over time.') }}</p>
						<p class="text-white-200 italic text-xs tracking-wide">
							Read
							<Button
								:as="RouterLinkComp"
								to="/about"
								variant="outline"
								size="sm"
								class="rounded-none"
							>
								About
							</Button>
							for a quick overview.
						</p>
						<div class="flex flex-wrap gap-3">
							<Button
								:as="RouterLinkComp"
								to="/learningpool"
								variant="default"
								size="sm"
								class="rounded-none bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed"
							>
								Start now
								<span aria-hidden>→</span>
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
								class="rounded-none"
							>
								Create path
							</Button>
						</div>
					</template>
					<template v-else>
						<h1 class="text-xl md:text-2xl font-bold leading-tight">{{ bannerSlides[activeBannerIndex].title }}</h1>
						<p class="text-white/90">{{ bannerSlides[activeBannerIndex].description }}</p>
						<div class="flex flex-wrap gap-3">
							<Button
								:as="RouterLinkComp"
								to="/learningpool"
								variant="default"
								size="sm"
								class="rounded-none"
							>
								Explore
								<span aria-hidden>→</span>
							</Button>
							<Button
								:as="RouterLinkComp"
								to="/createpath"
								variant="outline"
								size="sm"
								class="rounded-none"
							>
								Create one
							</Button>
						</div>
					</template>
				</div>
				<div class="hidden md:block w-64 h-40 bg-white/10 backdrop-blur border border-white/20" aria-hidden>
					<div class="h-full w-full flex items-center justify-center text-white/70 text-sm">
						{{ bannerSlides[activeBannerIndex].tagline }}
					</div>
				</div>
			</div>


		</section>

		<section class="border-b border-border pb-8">
			<div class="grid gap-6 md:grid-cols-12 md:items-end">
				<div class="md:col-span-8">
					<h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">
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
							class="rounded-none bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed"
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
							class="rounded-none"
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
					variant="outline"
					size="sm"
					class="rounded-none"
				>
					View all
				</Button>
			</div>
			<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-5">
				<RouterLink
					v-for="path in featuredPaths"
					:key="path.id"
					:to="{ name: 'learningpath', params: { id: path.id } }"
					class="block"
				>
					<Card as="article" :hoverable="true" className="rounded-md">
						<div class="relative h-28 bg-gray-100">
							<img :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover" />
						</div>
						<div class="p-4 flex flex-col gap-3">
							<div class="space-y-1">
								<h3 class="text-foreground font-semibold tracking-tight text-sm leading-snug line-clamp-2" :title="path.title">{{ path.title }}</h3>
								<p class="text-muted-foreground text-sm leading-snug line-clamp-2" :title="path.description">{{ path.description }}</p>
							</div>
							<div class="flex items-center justify-between text-xs text-muted-foreground">
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
					variant="outline"
					size="sm"
					class="rounded-none"
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
					<Card as="article" :hoverable="true" className="rounded-md">
						<div :class="['relative bg-gray-100', randomCoverHeightClass(idx)]">
							<img :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover" />
						</div>
						<div class="p-4 flex flex-col gap-3">
							<div class="space-y-1">
								<h3 class="text-foreground font-semibold tracking-tight text-sm leading-snug line-clamp-2" :title="path.title">{{ path.title }}</h3>
								<p class="text-muted-foreground text-sm leading-snug line-clamp-2" :title="path.description">{{ path.description }}</p>
							</div>
							<div class="flex items-center justify-between text-xs text-muted-foreground">
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
import { computed, ref, onBeforeUnmount, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'
import { useI18n } from '../i18n'
import { listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'

const RouterLinkComp = RouterLink

const { t } = useI18n()

const bannerSlides = [
	{
		image: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&h=900&q=80',
		title: '',
		description: '',
		tagline: 'Platform intro',
	},
	{
		image: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1600&h=900&q=80',
		title: 'Linear Learning Paths',
		description: 'Step-by-step, guided learning. Follow a clear sequence and finish with a complete outcome.',
		tagline: 'Linear path',
	},
	{
		image: 'https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&w=1600&h=900&q=80',
		title: 'Structured Learning Paths',
		description: 'A structured curriculum with modules and goals. Great for system-level skill building and planning.',
		tagline: 'Structured path',
	},
	{
		image: 'https://images.unsplash.com/photo-1526378722463-4f3f0f0f1b1f?auto=format&fit=crop&w=1600&h=900&q=80',
		title: 'Partical Pool',
		description: 'A flexible pool of resources. Collect links, articles, and clips, then revisit and refine anytime.',
		tagline: 'Partical pool',
	},
] as const

const activeBannerIndex = ref(0)
let bannerTimer: ReturnType<typeof setInterval> | null = null

function nextBanner() {
	activeBannerIndex.value = (activeBannerIndex.value + 1) % bannerSlides.length
}

function startCarousel() {
	if (bannerTimer) return
	bannerTimer = setInterval(() => {
		nextBanner()
	}, 6500)
}

function stopCarousel() {
	if (!bannerTimer) return
	clearInterval(bannerTimer)
	bannerTimer = null
}

function pauseCarousel() {
	stopCarousel()
}

function resumeCarousel() {
	startCarousel()
}

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
	startCarousel()
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

onBeforeUnmount(() => {
	stopCarousel()
})
</script>
