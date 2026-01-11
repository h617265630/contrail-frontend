<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-gray-900 mb-2">Resource Library</h1>
        <p class="text-gray-600">Manage your learning resources and add them to learning paths</p>
      </div>

      <!-- Toolbar -->
      <div class="bg-white rounded-xl shadow-lg p-4 mb-6">
        <div class="flex flex-col lg:flex-row gap-4 items-start lg:items-center justify-between">
          <!-- Left side - Search and Filter -->
          <div class="flex flex-col sm:flex-row gap-3 flex-1 w-full lg:w-auto">
            <!-- Search -->
            <div class="relative flex-1">
              <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search resources..."
                v-model="searchQuery"
                class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <!-- Category Filter -->
            <div class="relative">
              <select
                v-model="selectedCategory"
                class="appearance-none pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white cursor-pointer"
              >
                <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
              </select>
              <Filter class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
              <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
            </div>
          </div>

          <!-- Right side - Actions -->
          <div class="flex gap-3 w-full lg:w-auto">
            <!-- View Mode Toggle -->
            <div class="flex gap-1 bg-gray-100 rounded-lg p-1">
              <button @click="setView('grid')" :class="['p-2 rounded', viewMode === 'grid' ? 'bg-white shadow-sm' : 'text-gray-500']">
                <Grid3x3 class="w-5 h-5" />
              </button>
              <button @click="setView('list')" :class="['p-2 rounded', viewMode === 'list' ? 'bg-white shadow-sm' : 'text-gray-500']">
                <List class="w-5 h-5" />
              </button>
            </div>

            <!-- Add to Path Button -->
            <button
              v-if="selectedResources.size > 0"
              @click="showAddToPathModal = true"
              class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors flex items-center gap-2"
            >
              <Plus class="w-4 h-4" />
              Add to Path ({{ selectedResources.size }})
            </button>

            <!-- Add Resource Button -->
            <button
              @click="showAddModal = true"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
            >
              <Plus class="w-4 h-4" />
              Add Resource
            </button>
          </div>
        </div>
      </div>

      <!-- Resources Display -->
      <div v-if="viewMode === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
        <div
          v-for="resource in filteredResources"
          :key="resource.id"
          :class="[
            'bg-white rounded-xl shadow-lg overflow-hidden transition-all cursor-pointer h-[360px] flex flex-col',
            selectedResources.has(resource.id) ? 'ring-4 ring-blue-500' : 'hover:shadow-xl',
          ]"
          @click="viewResource(resource)"
        >
          <!-- Thumbnail -->
            <div class="relative h-32">
            <img :src="resource.thumbnail" :alt="resource.title" class="w-full h-full object-cover" />

            <!-- Selection Checkbox -->
            <div class="absolute top-3 left-3">
              <button @click.stop="toggleResourceSelection(resource.id)"
                      :class="['w-6 h-6 rounded flex items-center justify-center', selectedResources.has(resource.id) ? 'bg-blue-600 text-white' : 'bg-white bg-opacity-80 text-gray-600 hover:bg-opacity-100']">
                <Check v-if="selectedResources.has(resource.id)" class="w-4 h-4" />
              </button>
            </div>

            <!-- Type Badge -->
            <div class="absolute top-3 right-3">
              <div :class="['px-2 py-1 rounded-full flex items-center gap-1', getTypeColor(resource.type)]">
                <component :is="typeIcon(resource.type)" class="w-4 h-4" />
                <span class="text-xs capitalize">{{ resource.type }}</span>
              </div>
            </div>

            <!-- Source Badge -->
            <div class="absolute bottom-3 left-3">
              <div class="px-2 py-1 rounded-full bg-black bg-opacity-60 text-white text-xs flex items-center gap-1">
                <LinkIcon class="w-3 h-3" />
                {{ resource.source }}
              </div>
            </div>
          </div>

          <!-- Content -->
          <div class="p-4 flex flex-col flex-1 min-h-0">
            <div class="flex items-start justify-between mb-2">
              <h3 class="text-gray-900 flex-1 font-semibold text-sm truncate">{{ resource.title }}</h3>
            </div>

            <p class="text-gray-600 text-sm mb-3 line-clamp-3">{{ resource.description }}</p>

            <!-- Meta Info -->
            <div class="flex items-center gap-4 text-xs text-gray-500 mb-3">
              <div class="flex items-center gap-1">
                <Tag class="w-3 h-3" />
                {{ resource.category }}
              </div>
              <div v-if="resource.duration">{{ resource.duration }}</div>
              <div v-if="resource.pages">{{ resource.pages }} pages</div>
            </div>

            <!-- Actions -->
            <div class="flex gap-2 mt-auto">
              <button @click.stop="viewResource(resource)" class="flex-1 px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                View
              </button>
              <button @click.stop="openEdit(resource)" class="flex-1 px-3 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors flex items-center justify-center gap-2">
                <Edit2 class="w-4 h-4" />
                Edit
              </button>
              <button @click.stop="handleDeleteResource(resource.id)" class="px-3 py-2 bg-red-100 text-red-600 rounded-lg hover:bg-red-200 transition-colors">
                <Trash2 class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="space-y-4">
        <div
          v-for="resource in filteredResources"
          :key="resource.id"
          :class="[
            'bg-white rounded-xl shadow-lg p-4 transition-all cursor-pointer',
            selectedResources.has(resource.id) ? 'ring-4 ring-blue-500' : 'hover:shadow-xl',
          ]"
          @click="viewResource(resource)"
        >
          <div class="flex gap-4">
            <!-- Selection Checkbox -->
            <button @click.stop="toggleResourceSelection(resource.id)"
                    :class="['w-10 h-10 rounded flex items-center justify-center flex-shrink-0', selectedResources.has(resource.id) ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200']">
              <Check v-if="selectedResources.has(resource.id)" class="w-5 h-5" />
            </button>

            <!-- Thumbnail -->
            <img :src="resource.thumbnail" :alt="resource.title" class="w-32 h-28 object-cover rounded-lg flex-shrink-0" />

            <!-- Content -->
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between gap-4 mb-2">
                <div class="flex-1">
                  <h3 class="text-gray-900 mb-1">{{ resource.title }}</h3>
                  <p class="text-gray-600 text-sm line-clamp-2">{{ resource.description }}</p>
                </div>
                <div :class="['px-2 py-1 rounded-full flex items-center gap-1', getTypeColor(resource.type), 'flex-shrink-0']">
                  <component :is="typeIcon(resource.type)" class="w-4 h-4" />
                  <span class="text-xs capitalize">{{ resource.type }}</span>
                </div>
              </div>

              <div class="flex items-center gap-4 text-xs text-gray-500">
                <div class="flex items-center gap-1">
                  <Tag class="w-3 h-3" />
                  {{ resource.category }}
                </div>
                <div class="flex items-center gap-1">
                  <LinkIcon class="w-3 h-3" />
                  {{ resource.source }}
                </div>
                <div v-if="resource.duration">{{ resource.duration }}</div>
                <div v-if="resource.pages">{{ resource.pages }} pages</div>
                <div>Added {{ resource.addedDate }}</div>
              </div>
            </div>

            <!-- Actions -->
            <div class="flex gap-2 flex-shrink-0">
              <button @click.stop="viewResource(resource)" class="px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                View
              </button>
              <button @click.stop="openEdit(resource)" class="px-3 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors flex items-center gap-2">
                <Edit2 class="w-4 h-4" />
                Edit
              </button>
              <button @click.stop="handleDeleteResource(resource.id)" class="px-3 py-2 bg-red-100 text-red-600 rounded-lg hover:bg-red-200 transition-colors">
                <Trash2 class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-if="filteredResources.length === 0" class="text-center py-16 bg-white rounded-xl shadow-lg">
        <BookOpen class="w-16 h-16 text-gray-300 mx-auto mb-4" />
        <h3 class="text-gray-900 mb-2">No resources found</h3>
        <p class="text-gray-600 mb-6">
          {{ searchQuery || selectedCategory !== 'All' ? 'Try adjusting your filters' : 'Start by adding your first resource' }}
        </p>
        <button v-if="!searchQuery && selectedCategory === 'All'"
                @click="showAddModal = true"
                class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors inline-flex items-center gap-2">
          <Plus class="w-4 h-4" />
          Add Resource
        </button>
      </div>
    </div>

    <!-- Add Resource Modal -->
    <div v-if="showAddModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
          <h2 class="text-gray-900">Add New Resource</h2>
          <button @click="showAddModal = false" class="text-gray-400 hover:text-gray-600">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div class="p-6 space-y-4">
          <!-- URL Input -->
          <div>
            <label class="block text-gray-700 mb-2">Resource URL *</label>
            <div class="relative">
              <LinkIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="url"
                placeholder="Paste link from 小红书, X, YouTube, etc."
                v-model="newResource.url"
                class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>

          <!-- Title -->
          <div>
            <label class="block text-gray-700 mb-2">Title *</label>
            <input
              type="text"
              placeholder="Enter resource title"
              v-model="newResource.title"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <!-- Description -->
          <div>
            <label class="block text-gray-700 mb-2">Description</label>
            <textarea
              placeholder="Brief description of the resource"
              v-model="newResource.description"
              rows="3"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
            />
          </div>

          <!-- Type and Category -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-gray-700 mb-2">Type *</label>
              <select v-model="newResource.type" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="video">Video</option>
                <option value="document">Document</option>
                <option value="article">Article</option>
              </select>
            </div>

            <div>
              <label class="block text-gray-700 mb-2">Category *</label>
              <select v-model="newResource.category" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="">Select category</option>
                <option v-for="cat in categories.filter(c => c !== 'All')" :key="cat" :value="cat">{{ cat }}</option>
              </select>
            </div>
          </div>

          <!-- Source and Duration/Pages -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-gray-700 mb-2">Source</label>
              <input type="text" placeholder="e.g., 小红书, YouTube, X" v-model="newResource.source" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>

            <div>
              <label class="block text-gray-700 mb-2">{{ newResource.type === 'video' ? 'Duration' : 'Pages' }}</label>
              <input
                type="text"
                :placeholder="newResource.type === 'video' ? 'e.g., 45min' : 'e.g., 85'"
                v-model="durationOrPages"
                @input="updateDurationOrPages($event)"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>
        </div>

        <div class="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
          <button @click="showAddModal = false" class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">Cancel</button>
          <button @click="handleAddResource" :disabled="!newResource.title || !newResource.url || !newResource.category" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">Add Resource</button>
        </div>
      </div>
    </div>

    <!-- Edit Resource Modal -->
    <div v-if="showEditModal && editingResource" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
          <h2 class="text-gray-900">Edit Resource</h2>
          <button @click="closeEdit()" class="text-gray-400 hover:text-gray-600">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div class="p-6 space-y-4">
          <div>
            <label class="block text-gray-700 mb-2">Title *</label>
            <input type="text" v-model="editingResource.title" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>

          <div>
            <label class="block text-gray-700 mb-2">Description</label>
            <textarea v-model="editingResource.description" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none" />
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-gray-700 mb-2">Category *</label>
              <select v-model="editingResource.category" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option v-for="cat in categories.filter(c => c !== 'All')" :key="cat" :value="cat">{{ cat }}</option>
              </select>
            </div>

            <div>
              <label class="block text-gray-700 mb-2">Source</label>
              <input type="text" v-model="editingResource.source" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>
          </div>
        </div>

        <div class="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
          <button @click="closeEdit()" class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">Cancel</button>
          <button @click="handleUpdateResource" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">Save Changes</button>
        </div>
      </div>
    </div>

    <!-- Add to Learning Path Modal -->
    <div v-if="showAddToPathModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
          <div>
            <h2 class="text-gray-900">Add to Learning Path</h2>
            <p class="text-gray-600 text-sm mt-1">{{ selectedResources.size }} resource(s) selected</p>
          </div>
          <button @click="showAddToPathModal = false" class="text-gray-400 hover:text-gray-600">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div class="p-6">
          <h3 class="text-gray-900 mb-4">Select Learning Path</h3>
          <div class="space-y-3">
            <div v-for="path in learningPaths" :key="path.id" class="border border-gray-200 rounded-lg p-4 hover:border-blue-500 transition-colors">
              <div class="flex items-start justify-between mb-3">
                <div>
                  <h4 class="text-gray-900">{{ path.title }}</h4>
                  <p class="text-sm text-gray-600">{{ path.itemCount }} items</p>
                </div>
                <button class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2">
                  <ArrowRight class="w-4 h-4" />
                  Select
                </button>
              </div>

              <!-- Position Selection -->
              <div class="border-t border-gray-200 pt-3">
                <label class="block text-sm text-gray-700 mb-2">Insert Position</label>
                <select class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                  <option value="end">At the end</option>
                  <option value="start">At the beginning</option>
                  <option value="after-1">After item #1</option>
                  <option value="after-2">After item #2</option>
                  <option value="after-3">After item #3</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <div class="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
          <button @click="showAddToPathModal = false" class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Plus, Search, Grid3x3, List, Edit2, Trash2, Link as LinkIcon, Video, FileText, BookOpen, Tag, Filter, ChevronDown, X, Check, ArrowRight } from 'lucide-vue-next'
import { type Resource } from '../data/resources'
import { deleteResource, listAllResources, upsertResource } from '../data/resourcesStore'

interface LearningPath {
  id: string;
  title: string;
  itemCount: number;
}

const resources = ref<Resource[]>([])

const router = useRouter()

const viewMode = ref<'grid' | 'list'>('grid')
const selectedCategory = ref<string>('All')
const searchQuery = ref('')
const showAddModal = ref(false)
const showEditModal = ref(false)
const showAddToPathModal = ref(false)
const selectedResources = ref<Set<string>>(new Set())
const editingResource = ref<Resource | null>(null)

const learningPaths = ref<LearningPath[]>([
  { id: '1', title: 'Full Stack Web Development', itemCount: 5 },
  { id: '2', title: 'Backend Engineering', itemCount: 3 },
  { id: '3', title: 'Frontend Mastery', itemCount: 4 },
])

const newResource = ref<{ title: string; description: string; url: string; type: 'video' | 'document' | 'article'; category: string; source: string; duration: string; pages: string }>({
  title: '', description: '', url: '', type: 'video', category: '', source: '', duration: '', pages: ''
})

const categories = ['All', 'Frontend', 'Backend', 'Database', 'DevOps', 'Design', 'Custom', 'Other']

const filteredResources = computed(() => {
  return resources.value.filter(resource => {
    const matchesCategory = selectedCategory.value === 'All' || resource.category === selectedCategory.value
    const q = searchQuery.value.toLowerCase()
    const matchesSearch = resource.title.toLowerCase().includes(q) || resource.description.toLowerCase().includes(q)
    return matchesCategory && matchesSearch
  })
})

function setView(mode: 'grid' | 'list') {
  viewMode.value = mode
}

function handleAddResource() {
  const resource: Resource = {
    id: Date.now().toString(),
    title: newResource.value.title,
    description: newResource.value.description,
    url: newResource.value.url,
    type: newResource.value.type,
    category: newResource.value.category,
    thumbnail: `https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400&h=225&fit=crop&sig=${Date.now()}`,
    duration: newResource.value.duration,
    pages: newResource.value.pages ? parseInt(newResource.value.pages) : undefined,
    addedDate: new Date().toISOString().split('T')[0],
    source: newResource.value.source,
  }
  upsertResource(resource)
  resources.value = listAllResources()
  showAddModal.value = false
  newResource.value = { title: '', description: '', url: '', type: 'video', category: '', source: '', duration: '', pages: '' }
}

function handleUpdateResource() {
  if (!editingResource.value) return
  upsertResource(editingResource.value)
  resources.value = listAllResources()
  showEditModal.value = false
  editingResource.value = null
}

function handleDeleteResource(id: string) {
  if (confirm('Are you sure you want to delete this resource?')) {
    deleteResource(id)
    resources.value = listAllResources()
    const next = new Set(selectedResources.value)
    next.delete(id)
    selectedResources.value = next
  }
}

onMounted(() => {
  resources.value = listAllResources()
})

function toggleResourceSelection(id: string) {
  const next = new Set(selectedResources.value)
  if (next.has(id)) next.delete(id)
  else next.add(id)
  selectedResources.value = next
}

function typeIcon(type: string) {
  switch (type) {
    case 'video': return Video
    case 'document': return FileText
    case 'article': return BookOpen
    default: return FileText
  }
}

function getTypeColor(type: string) {
  switch (type) {
    case 'video': return 'bg-purple-100 text-purple-600'
    case 'document': return 'bg-blue-100 text-blue-600'
    case 'article': return 'bg-green-100 text-green-600'
    default: return 'bg-gray-100 text-gray-600'
  }
}

function viewResource(resource: Resource) {
  if (resource.type === 'video') {
    router.push({ name: 'resource-video', params: { id: resource.id } })
    return
  }
  if (resource.type === 'document') {
    router.push({ name: 'resource-document', params: { id: resource.id } })
    return
  }
  window.open(resource.url, '_blank')
}

function openEdit(resource: Resource) {
  editingResource.value = { ...resource }
  showEditModal.value = true
}

function closeEdit() {
  showEditModal.value = false
  editingResource.value = null
}

const durationOrPages = computed({
  get() { return newResource.value.type === 'video' ? newResource.value.duration : newResource.value.pages },
  set(val: string) {
    if (newResource.value.type === 'video') newResource.value.duration = val as any
    else newResource.value.pages = val as any
  }
})

function updateDurationOrPages(e: Event) {
  const val = (e.target as HTMLInputElement).value
  durationOrPages.value = val
}
</script>
