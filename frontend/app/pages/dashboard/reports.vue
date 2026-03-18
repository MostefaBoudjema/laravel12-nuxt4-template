<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth',
  title: 'analytical_reports'
})

const { t } = useI18n()
const auth = useAuthStore()
const api = useApi()

// Redirect to unauthorized if not admin or manager (manual check in page as example)
onMounted(() => {
  if (!auth.hasRole('admin') && !auth.hasRole('manager')) {
    navigateTo('/unauthorized')
  }
})

// Search and Debounce Logic
const searchQuery = ref('')
const deferredSearch = ref('')
let debounceTimeout: any = null

const { data: reportsData, pending, refresh } = await useFetch<any>('/reports', {
  baseURL: useRuntimeConfig().public.apiBase as string,
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

const summary = computed(() => reportsData.value?.data?.summary || {})
const recent = computed(() => reportsData.value?.data?.recent_registrations || [])
</script>

<template>
  <div class="space-y-8">
    <div class="flex justify-between items-end">
      <div>
        <h2 class="text-2xl font-bold text-slate-800 dark:text-slate-200 tracking-tight">{{ t('system_statistics') }}</h2>
        <p class="text-slate-500 dark:text-slate-400">{{ t('real_time_breakdown') }}</p>
      </div>
      <div class="flex items-center gap-4">
        <UiInput
          v-model="searchQuery"
          id="reports-search"
          type="text"
          :placeholder="t('search_users') || 'Search users...'"
          size="sm"
        >
          <template #left>
            <fa icon="search" />
          </template>
          <template #right>
            <button v-if="searchQuery" @click="searchQuery = ''" class="text-slate-400 hover:text-rose-500 transition-colors">
              <fa icon="times" />
            </button>
          </template>
        </UiInput>
        <UiBadge variant="default" size="md">
          {{ t('updated') }}: {{ reportsData?.data?.generated_at ? new Date(reportsData.data.generated_at).toLocaleTimeString() : '...' }}
        </UiBadge>
      </div>
    </div>

    <!-- Summary Widgets -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <UiCard v-for="(val, key) in summary" :key="key" class="relative overflow-hidden">
        <div class="absolute right-0 top-0 h-full w-2 bg-indigo-500"></div>
        <p class="text-xs font-bold text-slate-400 dark:text-slate-500 uppercase tracking-wider mb-2">{{ key.replace('_', ' ') }}</p>
        <p class="text-4xl font-extrabold text-slate-800 dark:text-slate-100">{{ val }}</p>
        <div class="mt-4 flex items-center gap-2">
          <UiBadge variant="success" size="sm">
            <fa icon="check-circle" class="mr-1" />
            {{ t('active_verified') }}
          </UiBadge>
        </div>
      </UiCard>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Recent Registrations -->
      <UiCard variant="default" :padded="false" class="lg:col-span-2 overflow-hidden">
        <template #header>
          <div class="px-8 py-6 border-b border-slate-50 dark:border-slate-800 bg-slate-50/30 dark:bg-slate-800/50">
            <h3 class="font-bold text-slate-800 dark:text-slate-200">{{ t('recent_registrations') }}</h3>
          </div>
        </template>

        <div class="p-0">
          <div v-for="user in recent" :key="user.id" class="px-8 py-5 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors border-b last:border-0 border-slate-50 dark:border-slate-800">
             <div class="flex items-center gap-3">
               <div class="w-10 h-10 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center font-bold text-slate-400 dark:text-slate-500">
                 {{ user.name.charAt(0) }}
               </div>
               <div>
                 <p class="font-bold text-sm text-slate-800 dark:text-slate-200">{{ user.name }}</p>
                 <p class="text-xs text-slate-400 dark:text-slate-500">{{ user.email }}</p>
               </div>
             </div>
             <div class="text-right">
               <p class="text-xs font-bold text-slate-800 dark:text-slate-200">{{ new Date(user.created_at).toLocaleDateString() }}</p>
               <p class="text-[10px] text-slate-400 dark:text-slate-500 uppercase font-bold tracking-widest">{{ new Date(user.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) }}</p>
             </div>
          </div>
        </div>
      </UiCard>

      <!-- Quick Analysis -->
      <UiCard class="text-white !bg-white dark:!bg-slate-900 !border-slate-100 dark:!border-slate-800">
        <h3 class="font-bold text-xl mb-6 text-slate-800 dark:text-slate-200">{{ t('growth_analysis') }}</h3>
        <div class="space-y-8">
          <div>
            <div class="flex justify-between mb-2">
              <span class="text-sm text-slate-400 dark:text-slate-300">{{ t('retention_rate') }}</span>
              <span class="text-sm font-bold text-slate-800 dark:text-slate-200">84%</span>
            </div>
            <div class="w-full bg-slate-100 dark:bg-white/5 h-2 rounded-full overflow-hidden">
              <div class="bg-indigo-500 h-full w-[84%]"></div>
            </div>
          </div>
          <div>
            <div class="flex justify-between mb-2">
              <span class="text-sm text-slate-400 dark:text-slate-300">{{ t('api_uptime') }}</span>
              <span class="text-sm font-bold text-slate-800 dark:text-slate-200">99.9%</span>
            </div>
            <div class="w-full bg-slate-100 dark:bg-white/5 h-2 rounded-full overflow-hidden">
              <div class="bg-emerald-500 h-full w-[99.9%]"></div>
            </div>
          </div>
          <div>
            <div class="flex justify-between mb-2">
              <span class="text-sm text-slate-400 dark:text-slate-300">{{ t('server_load') }}</span>
              <span class="text-sm font-bold text-slate-800 dark:text-slate-200">12%</span>
            </div>
            <div class="w-full bg-slate-100 dark:bg-white/5 h-2 rounded-full overflow-hidden">
              <div class="bg-amber-500 h-full w-[12%]"></div>
            </div>
          </div>
        </div>
        
        <div class="mt-12 p-6 rounded-2xl bg-slate-50 dark:bg-white/5 border border-slate-100 dark:border-white/10">
           <p class="text-sm text-slate-500 dark:text-slate-400 leading-relaxed italic">
             "{{ t('peak_efficiency_msg') }}"
           </p>
        </div>
      </UiCard>
    </div>
  </div>
</template>
