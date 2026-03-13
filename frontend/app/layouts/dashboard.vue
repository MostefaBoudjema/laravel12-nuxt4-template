<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'
const auth = useAuthStore()
const { t } = useI18n()
const isSidebarOpen = ref(false)

const navLinks = [
  { to: '/', icon: 'dashboard', label: 'dashboard' },
  { to: '/users', icon: 'users', label: 'users', role: 'admin' },
  { to: '/reports', icon: 'chart-bar', label: 'reports', roles: ['admin', 'manager'] },
  { to: '/settings', icon: 'cog', label: 'settings' }
]

const filteredLinks = computed(() => {
  return navLinks.filter(link => {
    if (link.role && !auth.hasRole(link.role)) return false
    if (link.roles && !link.roles.some(r => auth.hasRole(r))) return false
    return true
  })
})
</script>

<template>
  <div class="flex min-h-screen dark:bg-slate-900 bg-slate-50 dark:text-white text-slate-900 overflow-hidden font-sans transition-colors duration-300">
    <!-- Sidebar Overlay -->
    <div v-if="isSidebarOpen" @click="isSidebarOpen = false" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-40 lg:hidden"></div>

    <!-- Sidebar -->
    <aside 
      class="fixed inset-y-0 left-0 z-50 w-72 dark:bg-slate-800 bg-white border-r border-slate-200 dark:border-white/10 flex flex-col transition-transform duration-300 lg:translate-x-0"
      :class="isSidebarOpen ? 'translate-x-0' : '-translate-x-full'"
    >
      <div class="p-8 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 bg-indigo-600 rounded-xl flex items-center justify-center shadow-lg shadow-indigo-500/20">
            <fa icon="dashboard" class="text-white" />
          </div>
          <span class="text-xl font-bold tracking-tight dark:text-white text-slate-800">{{ t('saas_app') }}</span>
        </div>
        <button @click="isSidebarOpen = false" class="lg:hidden p-2 text-slate-400">
          <fa icon="times" />
        </button>
      </div>

      <nav class="flex-1 px-4 space-y-1 overflow-y-auto">
        <NuxtLink 
          v-for="link in filteredLinks" 
          :key="link.to"
          :to="link.to" 
          @click="isSidebarOpen = false"
          class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 hover:bg-indigo-50 dark:hover:bg-white/5 group hover:text-indigo-600 dark:hover:text-indigo-400 font-medium" 
          :class="{'bg-indigo-600 text-white shadow-lg hover:text-white dark:hover:text-white': $route.path === link.to}"
        >
          <fa :icon="link.icon" />
          <span>{{ t(link.label) }}</span>
        </NuxtLink>
      </nav>

      <div class="p-4 border-t border-slate-100 dark:border-white/10">
        <button @click="auth.logout()" class="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-500/10 transition-all duration-200 font-medium group text-left">
          <fa icon="sign-out-alt" class="group-hover:translate-x-1 transition-transform" />
          <span>{{ t('logout') }}</span>
        </button>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col lg:ml-72 min-h-screen overflow-y-auto">
      <!-- Topbar -->
      <header class="h-20 dark:bg-slate-900/80 bg-white/80 backdrop-blur-md border-b border-slate-200 dark:border-white/10 flex items-center justify-between px-4 md:px-8 sticky top-0 z-40 transition-colors">
        <div class="flex items-center gap-4">
          <button @click="isSidebarOpen = true" class="lg:hidden p-2 text-slate-500 dark:text-slate-400">
            <fa icon="bars" />
          </button>
          <h1 class="text-xl font-semibold dark:text-white text-slate-800 hidden sm:block">
            {{ $route.meta.title ? t($route.meta.title.toString().toLowerCase().replace(/\s+/g, '_')) : t('welcome') }}
          </h1>
        </div>

        <div class="flex items-center gap-6">
          <ColorLanguageSwitcher />
          
          <div class="flex items-center gap-3 border-l border-slate-200 dark:border-white/10 pl-6">
            <div class="text-right hidden sm:block">
              <p class="text-sm font-bold dark:text-white text-slate-900">{{ auth.user?.name }}</p>
              <p class="text-xs text-slate-500 uppercase font-semibold tracking-wider">{{ auth.user?.roles[0] }}</p>
            </div>
            <div class="w-10 h-10 bg-gradient-to-br from-indigo-500 to-purple-600 shadow-md rounded-full flex items-center justify-center font-bold text-white uppercase">
              {{ auth.user?.name.charAt(0) }}
            </div>
          </div>
        </div>
      </header>

      <main class="p-4 md:p-8">
        <slot />
      </main>
    </div>
  </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

body {
  font-family: 'Inter', sans-serif;
  margin: 0;
  padding: 0;
}

.router-link-active:not(#logout) {
  @apply bg-indigo-600 text-white shadow-lg shadow-indigo-500/20 dark:shadow-none;
}
</style>
