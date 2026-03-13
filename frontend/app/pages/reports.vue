<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth',
  title: 'analytical_reports'
})

const { t } = useI18n()
const auth = useAuthStore()
const config = useRuntimeConfig()

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
        <div class="relative group">
          <fa icon="search" class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-indigo-500 transition-colors" />
          <input 
            v-model="searchQuery"
            type="text" 
            :placeholder="t('search_users') || 'Search users...'"
            class="pl-11 pr-10 py-2 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-xs focus:ring-2 focus:ring-indigo-500 outline-none w-48 transition-all shadow-sm"
          />
          <button 
            v-if="searchQuery" 
            @click="searchQuery = ''"
            class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-rose-500 transition-colors shrink-0"
          >
            <fa icon="times" />
          </button>
        </div>
        <div class="text-xs font-bold text-slate-400 dark:text-slate-500 uppercase tracking-widest bg-slate-100 dark:bg-slate-800 px-3 py-1.5 rounded-lg border border-slate-200 dark:border-slate-700">
          {{ t('updated') }}: {{ reportsData?.data?.generated_at ? new Date(reportsData.data.generated_at).toLocaleTimeString() : '...' }}
        </div>
      </div>
    </div>

    <!-- Summary Widgets -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <div v-for="(val, key) in summary" :key="key" class="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm relative overflow-hidden">
        <div class="absolute right-0 top-0 h-full w-2 bg-indigo-500"></div>
        <p class="text-xs font-bold text-slate-400 dark:text-slate-500 uppercase tracking-wider mb-2">{{ key.replace('_', ' ') }}</p>
        <p class="text-4xl font-extrabold text-slate-800 dark:text-slate-100">{{ val }}</p>
        <div class="mt-4 flex items-center gap-2 text-emerald-500 font-bold text-xs">
          <fa icon="check-circle" />
          <span>{{ t('active_verified') }}</span>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Recent Registrations -->
      <div class="lg:col-span-2 bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm overflow-hidden">
        <div class="px-8 py-6 border-b border-slate-50 dark:border-slate-800 bg-slate-50/30 dark:bg-slate-800/50 flex justify-between items-center">
          <h3 class="font-bold text-slate-800 dark:text-slate-200">{{ t('recent_registrations') }}</h3>
        </div>
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
      </div>

      <!-- Quick Analysis -->
      <div class="bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 rounded-3xl p-8 text-white">
        <h3 class="font-bold text-xl mb-6 text-slate-800 dark:text-slate-200">{{ t('growth_analysis') }}</h3>
        <div class="space-y-8">
          <div>
            <div class="flex justify-between mb-2">
              <span class="text-sm text-slate-400 dark:text-slate-300">{{ t('retention_rate') }}</span>
              <span class="text-sm font-bold text-white">84%</span>
            </div>
            <div class="w-full bg-white/10 dark:bg-white/5 h-2 rounded-full overflow-hidden">
              <div class="bg-indigo-500 h-full w-[84%]"></div>
            </div>
          </div>
          <div>
            <div class="flex justify-between mb-2">
              <span class="text-sm text-slate-400 dark:text-slate-300">{{ t('api_uptime') }}</span>
              <span class="text-sm font-bold text-white">99.9%</span>
            </div>
            <div class="w-full bg-white/10 dark:bg-white/5 h-2 rounded-full overflow-hidden">
              <div class="bg-emerald-500 h-full w-[99.9%]"></div>
            </div>
          </div>
          <div>
            <div class="flex justify-between mb-2">
              <span class="text-sm text-slate-400 dark:text-slate-300">{{ t('server_load') }}</span>
              <span class="text-sm font-bold text-white">12%</span>
            </div>
            <div class="w-full bg-white/10 dark:bg-white/5 h-2 rounded-full overflow-hidden">
              <div class="bg-amber-500 h-full w-[12%]"></div>
            </div>
          </div>
        </div>
        
        <div class="mt-12 p-6 rounded-2xl bg-white/5 dark:bg-white/10 border border-white/10 dark:border-white/20">
           <p class="text-sm text-white/60 dark:text-white/70 leading-relaxed italic">
             "{{ t('peak_efficiency_msg') }}"
           </p>
        </div>
      </div>
    </div>
  </div>
</template>
