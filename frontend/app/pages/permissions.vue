<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'dashboard',
  middleware: ['auth', 'role'],
  role: 'admin',
  title: 'permission_management'
})

const { t } = useI18n()
const auth = useAuthStore()
const config = useRuntimeConfig()

// Search and Debounce Logic
const searchQuery = ref('')
const deferredSearch = ref('')
let debounceTimeout: any = null

const { data: permissionsData, pending, refresh } = await useFetch<any>('/permissions', {
  baseURL: config.public.apiBase,
  query: { search: deferredSearch },
  headers: {
    Authorization: `Bearer ${auth.token}`
  }
})

// Update search results only 1s after typing stops
watch(searchQuery, (newVal) => {
  if (debounceTimeout) clearTimeout(debounceTimeout)
  
  if (newVal.trim() === '') {
    deferredSearch.value = ''
    return
  }

  debounceTimeout = setTimeout(() => {
    deferredSearch.value = newVal.trim()
  }, 1000)
})

onUnmounted(() => {
  if (debounceTimeout) clearTimeout(debounceTimeout)
})

const permissions = computed(() => permissionsData.value?.data || [])

// CRUD State
const isModalOpen = ref(false)
const isEditing = ref(false)
const submitting = ref(false)
const currentPermissionId = ref<number | null>(null)
const form = ref({
  name: ''
})

const openAddModal = () => {
  isEditing.value = false
  currentPermissionId.value = null
  form.value = { name: '' }
  isModalOpen.value = true
}

const openEditModal = (permission: any) => {
  isEditing.value = true
  currentPermissionId.value = permission.id
  form.value = {
    name: permission.name
  }
  isModalOpen.value = true
}

const closeModal = () => {
  isModalOpen.value = false
}

const handleSubmit = async () => {
  submitting.value = true
  try {
    const url = isEditing.value ? `/permissions/${currentPermissionId.value}` : '/permissions'
    const method = isEditing.value ? 'PUT' : 'POST'
    
    await $fetch<any>(url, {
      baseURL: config.public.apiBase,
      method,
      headers: {
        Authorization: `Bearer ${auth.token}`
      },
      body: form.value
    })

    await refresh()
    closeModal()
  } catch (err: any) {
    console.error('Error saving permission:', err)
  } finally {
    submitting.value = false
  }
}

const deletePermission = async (permissionId: number) => {
  if (!confirm(t('delete_confirm'))) return

  try {
    await $fetch(`/permissions/${permissionId}`, {
      baseURL: config.public.apiBase,
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${auth.token}`
      }
    })
    await refresh()
  } catch (err: any) {
    console.error('Error deleting permission:', err)
  }
}
</script>

<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <div>
        <h2 class="text-2xl font-bold text-slate-800 dark:text-slate-200">{{ t('system_permissions') }}</h2>
        <p class="text-slate-500 dark:text-slate-400">{{ t('manage_permissions') }}</p>
      </div>
      <div class="flex items-center gap-4">
        <div class="relative group">
          <fa icon="search" class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-indigo-500 transition-colors" />
          <input 
            v-model="searchQuery"
            type="text" 
            :placeholder="t('search_permissions') || 'Search permissions...'"
            class="pl-11 pr-10 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-sm focus:ring-2 focus:ring-indigo-500 outline-none w-64 transition-all shadow-sm"
          />
          <button 
            v-if="searchQuery" 
            @click="searchQuery = ''"
            class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-rose-500 transition-colors shrink-0"
          >
            <fa icon="times" />
          </button>
        </div>
        <div class="flex gap-3">
          <button @click="refresh" class="flex items-center gap-2 bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 px-5 py-2.5 rounded-xl font-semibold hover:bg-slate-200 dark:hover:bg-slate-700 transition-all active:scale-95">
            <fa icon="sync" :class="{ 'animate-spin': pending }" />
          </button>
          <button @click="openAddModal" class="flex items-center gap-2 bg-indigo-600 text-white px-5 py-2.5 rounded-xl font-semibold hover:bg-indigo-700 transition-all shadow-md active:scale-95">
            <fa icon="plus" />
            {{ t('add_permission') }}
          </button>
        </div>
      </div>
    </div>

    <div v-if="error" class="bg-rose-50 dark:bg-rose-950 border border-rose-100 dark:border-rose-900 p-6 rounded-2xl text-rose-600 dark:text-rose-400 flex items-center gap-4">
      <fa icon="exclamation-triangle" class="text-xl" />
      <div>
        <p class="font-bold">{{ t('failed_load_permissions') }}</p>
        <p class="text-sm">{{ error.message }}</p>
      </div>
    </div>

    <div v-else class="bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm overflow-hidden">
      <table class="w-full text-left">
        <thead class="bg-slate-50 dark:bg-slate-800 border-b border-slate-100 dark:border-slate-700">
          <tr>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('permission_name') }}</th>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('slug') }}</th>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('actions_header') }}</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-50 dark:divide-slate-800">
          <tr v-for="permission in permissions" :key="permission.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-800/50 transition-colors">
            <td class="px-8 py-6">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-full bg-emerald-100 dark:bg-emerald-900 flex items-center justify-center font-bold text-emerald-700 dark:text-emerald-300">
                  {{ permission.name.charAt(0).toUpperCase() }}
                </div>
                <p class="font-bold text-slate-800 dark:text-slate-200">{{ permission.name.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ') }}</p>
              </div>
            </td>
            <td class="px-8 py-6">
              <span class="px-3 py-1 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 font-mono text-xs border border-slate-200 dark:border-slate-700">
                {{ permission.name }}
              </span>
            </td>
            <td class="px-8 py-6">
              <div class="flex items-center gap-4">
                <button @click="openEditModal(permission)" class="text-slate-400 hover:text-indigo-600 transition-colors">
                  <fa icon="edit" />
                </button>
                <button @click="deletePermission(permission.id)" class="text-slate-400 hover:text-rose-600 transition-colors">
                  <fa icon="trash" />
                </button>
              </div>
            </td>
          </tr>
          <tr v-if="permissions.length === 0 && !pending">
            <td colspan="3" class="px-8 py-20 text-center text-slate-400 dark:text-slate-500">
              {{ t('no_permissions_found') }}
            </td>
          </tr>
        </tbody>
      </table>
      
      <div v-if="pending" class="p-12 flex justify-center items-center gap-4">
        <fa icon="cog" class="text-indigo-600 dark:text-indigo-400 text-2xl animate-spin" />
        <span class="font-medium text-slate-500 dark:text-slate-400">{{ t('loading_permissions') }}</span>
      </div>
    </div>

    <!-- Drawer -->
    <Transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="translate-x-full"
      enter-to-class="translate-x-0"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="translate-x-0"
      leave-to-class="translate-x-full"
    >
      <div v-if="isModalOpen" class="fixed inset-y-0 right-0 z-50 w-full max-w-md bg-white dark:bg-slate-900 shadow-2xl border-l border-slate-100 dark:border-slate-800 flex flex-col">
        <div class="px-8 py-6 border-b border-slate-100 dark:border-slate-700 flex justify-between items-center">
          <h3 class="text-xl font-bold text-slate-800 dark:text-slate-200">{{ isEditing ? t('edit_permission') : t('add_permission') }}</h3>
          <button @click="closeModal" class="w-10 h-10 flex items-center justify-center rounded-xl bg-slate-50 dark:bg-slate-800 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 transition-colors">
            <fa icon="times" />
          </button>
        </div>
        
        <form @submit.prevent="handleSubmit" class="flex-1 flex flex-col h-full">
          <div class="flex-1 p-8 space-y-6">
            <div class="space-y-3">
              <label class="text-sm font-bold text-slate-600 dark:text-slate-400 uppercase tracking-wider flex items-center gap-2">
                <fa icon="key" class="text-indigo-500" />
                {{ t('permission_name') }}
              </label>
              <input 
                v-model="form.name" 
                type="text" 
                required
                class="w-full px-5 py-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-800 dark:text-slate-200 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all shadow-sm"
                placeholder="e.g. manage-users"
              />
              <p class="text-xs text-slate-500 italic px-1">{{ t('use_kebab_case') || 'Use kebab-case for permission names (e.g. view-dashboard)' }}</p>
            </div>

            <div v-if="!isEditing" class="p-4 rounded-2xl bg-indigo-50 dark:bg-indigo-900/20 border border-indigo-100 dark:border-indigo-800/50">
              <div class="flex gap-3">
                <fa icon="info-circle" class="text-indigo-500 mt-0.5" />
                <p class="text-xs text-indigo-700 dark:text-indigo-300 leading-relaxed font-medium">
                  {{ t('permission_info') || 'New permissions are automatically attached to the system guard. You can assign them to roles after creation.' }}
                </p>
              </div>
            </div>
          </div>

          <div class="p-8 bg-slate-50/50 dark:bg-slate-800/30 border-t border-slate-100 dark:border-slate-700 flex justify-end gap-4">
            <button type="button" @click="closeModal" class="px-6 py-3 rounded-2xl font-bold text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-all">
              {{ t('cancel') }}
            </button>
            <button type="submit" :disabled="submitting" class="flex items-center gap-3 bg-indigo-600 text-white px-8 py-3 rounded-2xl font-bold hover:bg-indigo-700 transition-all shadow-lg shadow-indigo-500/25 active:scale-95 disabled:opacity-50">
              <fa v-if="submitting" icon="cog" class="animate-spin" />
              {{ t('save_permission') }}
            </button>
          </div>
        </form>
      </div>
    </Transition>

    <!-- Drawer Backdrop -->
    <Transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div v-if="isModalOpen" @click="closeModal" class="fixed inset-0 z-40 bg-slate-900/40 backdrop-blur-sm"></div>
    </Transition>
  </div>
</template>
