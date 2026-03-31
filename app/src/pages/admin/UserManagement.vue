<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <div>
        <h1 class="text-2xl font-bold text-stone-900">User Management</h1>
        <p class="text-sm text-stone-500 mt-1">Manage platform users and permissions</p>
      </div>
    </div>

    <!-- Search and filters -->
    <div class="flex flex-wrap gap-3 mb-6">
      <Input v-model="search" placeholder="Search users..." class="max-w-xs" @input="debouncedSearch" />
      <Select v-model="filterActive" @change="loadUsers">
        <option :value="undefined">All Status</option>
        <option :value="true">Active</option>
        <option :value="false">Inactive</option>
      </Select>
      <Select v-model="filterSuperuser" @change="loadUsers">
        <option :value="undefined">All Roles</option>
        <option :value="true">Superuser</option>
        <option :value="false">Regular User</option>
      </Select>
    </div>

    <!-- Users table -->
    <div class="rounded-lg border bg-white">
      <table class="w-full text-sm">
        <thead>
          <tr class="border-b bg-stone-50">
            <th class="px-4 py-3 text-left font-medium text-stone-600">User</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Email</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Status</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Roles</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Joined</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id" class="border-b last:border-0 hover:bg-stone-50">
            <td class="px-4 py-3">
              <div class="font-medium text-stone-900">{{ user.username }}</div>
              <div v-if="user.display_name" class="text-xs text-stone-500">{{ user.display_name }}</div>
            </td>
            <td class="px-4 py-3 text-stone-600">{{ user.email }}</td>
            <td class="px-4 py-3">
              <span
                class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium"
                :class="user.is_active ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'"
              >
                {{ user.is_active ? 'Active' : 'Inactive' }}
              </span>
            </td>
            <td class="px-4 py-3">
              <div class="flex flex-wrap gap-1">
                <span
                  v-for="role in user.roles"
                  :key="role"
                  class="inline-flex items-center px-2 py-0.5 rounded text-xs bg-amber-100 text-amber-700"
                >
                  {{ role }}
                </span>
                <span
                  v-if="user.is_superuser"
                  class="inline-flex items-center px-2 py-0.5 rounded text-xs bg-stone-900 text-white"
                >
                  Superuser
                </span>
              </div>
            </td>
            <td class="px-4 py-3 text-stone-500 text-xs">{{ formatDate(user.created_at) }}</td>
            <td class="px-4 py-3">
              <div class="flex gap-1">
                <Button
                  size="sm"
                  variant="ghost"
                  @click="toggleStatus(user)"
                  :disabled="user.id === currentUserId"
                >
                  {{ user.is_active ? 'Disable' : 'Enable' }}
                </Button>
                <Button
                  size="sm"
                  variant="ghost"
                  @click="toggleSuperuser(user)"
                  :disabled="user.id === currentUserId"
                >
                  {{ user.is_superuser ? 'Remove Admin' : 'Make Admin' }}
                </Button>
              </div>
            </td>
          </tr>
          <tr v-if="users.length === 0">
            <td colspan="6" class="px-4 py-8 text-center text-stone-500">No users found</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex justify-between items-center mt-4">
      <p class="text-sm text-stone-500">Total: {{ total }} users</p>
      <div class="flex gap-2">
        <Button variant="outline" size="sm" :disabled="skip === 0" @click="prevPage">Previous</Button>
        <Button variant="outline" size="sm" :disabled="skip + limit >= total" @click="nextPage">Next</Button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@/stores/auth'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { getAdminUsers, toggleUserStatus, toggleSuperuserStatus, type AdminUser } from '@/api/admin'

const authStore = useAuthStore()
const { user: authUser } = storeToRefs(authStore)
const currentUserId = computed(() => (authUser.value as any)?.id)

const users = ref<AdminUser[]>([])
const total = ref(0)
const skip = ref(0)
const limit = ref(20)
const search = ref('')
const filterActive = ref<boolean | undefined>(undefined)
const filterSuperuser = ref<boolean | undefined>(undefined)

let searchTimeout: ReturnType<typeof setTimeout>

async function loadUsers() {
  try {
    const data = await getAdminUsers({
      skip: skip.value,
      limit: limit.value,
      search: search.value || undefined,
      is_active: filterActive.value,
      is_superuser: filterSuperuser.value,
    })
    users.value = data.users
    total.value = data.total
  } catch (e) {
    console.error('Failed to load users', e)
  }
}

function debouncedSearch() {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    skip.value = 0
    loadUsers()
  }, 300)
}

function prevPage() {
  skip.value = Math.max(0, skip.value - limit.value)
  loadUsers()
}

function nextPage() {
  skip.value += limit.value
  loadUsers()
}

async function toggleStatus(user: AdminUser) {
  try {
    await toggleUserStatus(user.id)
    user.is_active = !user.is_active
  } catch (e) {
    console.error('Failed to toggle status', e)
  }
}

async function toggleSuperuser(user: AdminUser) {
  try {
    await toggleSuperuserStatus(user.id)
    user.is_superuser = !user.is_superuser
  } catch (e) {
    console.error('Failed to toggle superuser', e)
  }
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

onMounted(loadUsers)
</script>
