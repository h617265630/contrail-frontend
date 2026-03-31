<template>
  <div class="min-h-screen bg-background text-foreground flex flex-col">
    <NavBar />
    <main class="pt-16 py-6 px-4 flex-1">
      <router-view />
    </main>
    <AppFooter />

    <div v-if="showOnboarding" class="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-sm p-4" @click.self="skipOnboarding">
      <div class="w-full max-w-lg overflow-hidden rounded-2xl bg-white shadow-2xl">
        <div class="flex items-center justify-between border-b border-gray-200 p-6">
          <h2 class="text-lg font-semibold text-gray-900">Welcome</h2>
          <div class="flex items-center gap-2">
            <button
              type="button"
              class="rounded-lg px-3 py-2 text-sm font-semibold text-gray-600 hover:bg-gray-100"
              @click="skipOnboarding"
            >
              Skip
            </button>
            <button
              type="button"
              class="rounded-lg p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-600"
              @click="skipOnboarding"
              aria-label="Close"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
        </div>

        <div class="p-6">
          <div v-if="onboardingStep === 1" class="space-y-4">
            <div class="text-sm text-gray-700">Choose the categories you are interested in.</div>

            <div v-if="onboardingLoading" class="rounded-xl border border-gray-200 bg-gray-50 p-4 text-sm text-gray-600">
              Loading categories…
            </div>
            <div v-else class="grid grid-cols-1 gap-3">
              <label
                v-for="c in onboardingCategories"
                :key="c.id"
                class="flex items-start gap-3 rounded-xl border border-gray-200 p-3 hover:bg-gray-50"
              >
                <input
                  type="checkbox"
                  class="mt-1 h-4 w-4"
                  :value="c.id"
                  v-model="selectedCategoryIds"
                />
                <div class="min-w-0">
                  <div class="font-semibold text-gray-900">{{ c.name }}</div>
                  <div v-if="c.description" class="mt-1 text-xs text-gray-500">{{ c.description }}</div>
                </div>
              </label>
            </div>
          </div>

          <div v-else class="space-y-4">
            <div class="text-sm text-gray-700">Quick tour</div>
            <div class="grid grid-cols-1 gap-3">
              <div class="rounded-xl border border-gray-200 bg-white p-4">
                <div class="font-semibold text-gray-900">Resources</div>
                <div class="mt-1 text-sm text-gray-600">Browse public resources and open details.</div>
              </div>
              <div class="rounded-xl border border-gray-200 bg-white p-4">
                <div class="font-semibold text-gray-900">My Resources</div>
                <div class="mt-1 text-sm text-gray-600">Save resources to your library and edit metadata.</div>
              </div>
              <div class="rounded-xl border border-gray-200 bg-white p-4">
                <div class="font-semibold text-gray-900">Create Path</div>
                <div class="mt-1 text-sm text-gray-600">Build a learning path from your selected resources.</div>
              </div>
              <div class="rounded-xl border border-gray-200 bg-white p-4">
                <div class="font-semibold text-gray-900">Linear Learning</div>
                <div class="mt-1 text-sm text-gray-600">Follow a path step-by-step and track progress.</div>
              </div>
            </div>
          </div>
        </div>

        <div class="flex items-center justify-between gap-3 border-t border-gray-200 bg-gray-50 p-6">
          <div class="text-xs text-gray-500">Step {{ onboardingStep }} / 2</div>
          <div class="flex items-center gap-3">
            <button
              v-if="onboardingStep === 2"
              type="button"
              class="rounded-lg bg-white px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-100"
              @click="onboardingStep = 1"
            >
              Back
            </button>
            <button
              v-if="onboardingStep === 1"
              type="button"
              class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700"
              @click="goNextOnboarding"
            >
              Continue
            </button>
            <button
              v-else
              type="button"
              class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700"
              @click="finishOnboarding"
            >
              Get started
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from 'vue'
import NavBar from './components/NavBar.vue'
import AppFooter from './components/AppFooter.vue'
import { useAuthStore } from './stores/auth'
import { listCategories, type Category } from './api/category'
import { setAnalyticsUser } from './utils/analytics'

const authStore = useAuthStore()

const ONBOARDING_DONE_KEY = 'learnsmart_onboarding_done'
const ONBOARDING_INTERESTS_KEY = 'learnsmart_onboarding_category_ids'

const showOnboarding = ref(false)
const onboardingStep = ref<1 | 2>(1)
const onboardingLoading = ref(false)
const onboardingCategories = ref<Category[]>([])
const selectedCategoryIds = ref<number[]>([])

function readLocalFlag(key: string) {
  try {
    const storage = (globalThis as any).localStorage
    return storage?.getItem?.(key) || ''
  } catch {
    return ''
  }
}

function writeLocal(key: string, value: string) {
  try {
    const storage = (globalThis as any).localStorage
    storage?.setItem?.(key, value)
  } catch {
    // ignore
  }
}

async function ensureOnboardingCategories() {
  if (onboardingCategories.value.length) return
  onboardingLoading.value = true
  try {
    onboardingCategories.value = await listCategories()
  } catch {
    onboardingCategories.value = []
  } finally {
    onboardingLoading.value = false
  }
}

async function maybeShowOnboarding() {
  const done = readLocalFlag(ONBOARDING_DONE_KEY)
  if (done === '1' || done === 'true') return
  if (!authStore.isAuthed) return
  showOnboarding.value = true
  onboardingStep.value = 1
  await ensureOnboardingCategories()
}

function persistInterests() {
  writeLocal(ONBOARDING_INTERESTS_KEY, JSON.stringify(selectedCategoryIds.value || []))
}

function goNextOnboarding() {
  persistInterests()
  onboardingStep.value = 2
}

function finishOnboarding() {
  persistInterests()
  writeLocal(ONBOARDING_DONE_KEY, '1')
  showOnboarding.value = false
}

function skipOnboarding() {
  writeLocal(ONBOARDING_DONE_KEY, '1')
  showOnboarding.value = false
}

onMounted(() => {
  authStore
    .fetchProfile()
    .catch((error) => console.warn('Failed to initialize user profile:', error))
})

watch(
  () => authStore.isAuthed,
  (next) => {
    if (next) void maybeShowOnboarding()
  },
  { immediate: true },
)

watch(
  () => authStore.user,
  (next) => {
    setAnalyticsUser(next)
  },
  { immediate: true },
)
</script>
