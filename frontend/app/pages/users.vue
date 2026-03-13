<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'dashboard',
  middleware: ['auth', 'role'],
  role: 'admin',
  title: 'user_management'
})

const { t } = useI18n()
const auth = useAuthStore()
const config = useRuntimeConfig()

const { data: usersData, pending, error, refresh } = await useFetch<any>('/users', {
  baseURL: config.public.apiBase,
  headers: {
    Authorization: `Bearer ${auth.token}`
  }
})

const users = computed(() => usersData.value?.data || [])
</script>

<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <div>
        <h2 class="text-2xl font-bold text-slate-800 dark:text-slate-200">{{ t('system_users') }}</h2>
        <p class="text-slate-500 dark:text-slate-400">{{ t('manage_users') }}</p>
      </div>
      <button @click="refresh" class="flex items-center gap-2 bg-indigo-600 text-white px-5 py-2.5 rounded-xl font-semibold hover:bg-indigo-700 transition-all shadow-md active:scale-95">
        <fa icon="cog" :class="{ 'animate-spin': pending }" />
        {{ t('refresh_data') }}
      </button>
    </div>

    <div v-if="error" class="bg-rose-50 dark:bg-rose-950 border border-rose-100 dark:border-rose-900 p-6 rounded-2xl text-rose-600 dark:text-rose-400 flex items-center gap-4">
      <fa icon="exclamation-triangle" class="text-xl" />
      <div>
        <p class="font-bold">{{ t('failed_load_users') }}</p>
        <p class="text-sm">{{ error.message }}</p>
      </div>
    </div>

    <div v-else class="bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm overflow-hidden">
      <table class="w-full text-left">
        <thead class="bg-slate-50 dark:bg-slate-800 border-b border-slate-100 dark:border-slate-700">
          <tr>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('user_header') }}</th>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('roles_header') }}</th>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('permissions_header') }}</th>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('joined_header') }}</th>
            <th class="px-8 py-5 text-sm font-bold text-slate-600 dark:text-slate-300 uppercase tracking-wider">{{ t('actions_header') }}</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-50 dark:divide-slate-800">
          <tr v-for="user in users" :key="user.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-800/50 transition-colors">
            <td class="px-8 py-6">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-full bg-indigo-100 dark:bg-indigo-900 flex items-center justify-center font-bold text-indigo-700 dark:text-indigo-300">
                  {{ user.name.charAt(0) }}
                </div>
                <div>
                  <p class="font-bold text-slate-800 dark:text-slate-200">{{ user.name }}</p>
                  <p class="text-xs text-slate-500 dark:text-slate-400">{{ user.email }}</p>
                </div>
              </div>
            </td>
            <td class="px-8 py-6">
              <div class="flex flex-wrap gap-2">
                <span v-for="role in user.roles" :key="role" class="px-3 py-1 rounded-full text-[10px] font-bold uppercase bg-indigo-50 dark:bg-indigo-900 text-indigo-600 dark:text-indigo-300 border border-indigo-100 dark:border-indigo-800">
                  {{ role }}
                </span>
              </div>
            </td>
            <td class="px-8 py-6">
              <p class="text-xs text-slate-500 dark:text-slate-400 max-w-xs truncate">{{ user.permissions.join(', ') }}</p>
            </td>
            <td class="px-8 py-6 text-sm text-slate-500 dark:text-slate-400">
              {{ new Date(user.created_at).toLocaleDateString() }}
            </td>
            <td class="px-8 py-6">
              <button class="text-slate-400 hover:text-indigo-600 transition-colors">
                <fa icon="cog" />
              </button>
            </td>
          </tr>
          <tr v-if="users.length === 0 && !pending">
            <td colspan="5" class="px-8 py-20 text-center text-slate-400 dark:text-slate-500">
              {{ t('no_users_found') }}
            </td>
          </tr>
        </tbody>
      </table>
      
      <div v-if="pending" class="p-12 flex justify-center items-center gap-4">
        <fa icon="cog" class="text-indigo-600 dark:text-indigo-400 text-2xl animate-spin" />
        <span class="font-medium text-slate-500 dark:text-slate-400">{{ t('loading_users') }}</span>
      </div>
    </div>
  </div>
</template>
