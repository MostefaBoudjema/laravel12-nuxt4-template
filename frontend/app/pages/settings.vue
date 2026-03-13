<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth',
  title: 'profile_settings'
})

const { t } = useI18n()
const auth = useAuthStore()
const form = reactive({
  name: auth.user?.name || '',
  email: auth.user?.email || ''
})
const saving = ref(false)
const saved = ref(false)

const handleSave = () => {
  saving.value = true
  setTimeout(() => {
    saving.value = false
    saved.value = true
    setTimeout(() => saved.value = false, 3000)
  }, 1500)
}
</script>

<template>
  <div class="max-w-4xl mx-auto space-y-8">
    <div class="bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm p-10">
      <div class="flex items-start gap-8 border-b border-slate-50 dark:border-slate-800 pb-10 mb-10">
        <div class="w-32 h-32 rounded-3xl bg-gradient-to-tr from-indigo-500 to-indigo-700 flex items-center justify-center text-5xl text-white font-black shadow-xl shadow-indigo-100 dark:shadow-indigo-900/50">
          {{ auth.user?.name.charAt(0) }}
        </div>
        <div>
          <h2 class="text-3xl font-bold text-slate-800 dark:text-slate-200 mb-2">{{ auth.user?.name }}</h2>
          <p class="text-slate-500 dark:text-slate-400 mb-4">{{ auth.user?.email }}</p>
          <div class="flex gap-2">
            <span v-for="role in auth.user?.roles" :key="role" class="px-4 py-1.5 rounded-full text-xs font-bold bg-indigo-50 dark:bg-indigo-900 text-indigo-600 dark:text-indigo-300 border border-indigo-100 dark:border-indigo-800 uppercase tracking-widest">
              {{ role }}
            </span>
          </div>
        </div>
      </div>

      <form @submit.prevent="handleSave" class="space-y-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div>
            <label class="block text-sm font-bold text-slate-600 dark:text-slate-300 mb-3 ml-1 uppercase tracking-wider">{{ t('display_name') }}</label>
            <input v-model="form.name" type="text" class="w-full bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-700 rounded-2xl py-4 px-6 dark:text-slate-200 focus:ring-2 focus:ring-indigo-500 focus:bg-white dark:focus:bg-slate-700 outline-none transition-all" />
          </div>
          <div>
            <label class="block text-sm font-bold text-slate-600 dark:text-slate-300 mb-3 ml-1 uppercase tracking-wider">{{ t('email_address') }}</label>
            <input v-model="form.email" type="email" class="w-full bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-700 rounded-2xl py-4 px-6 dark:text-slate-200 focus:ring-2 focus:ring-indigo-500 focus:bg-white dark:focus:bg-slate-700 outline-none transition-all" />
          </div>
        </div>

        <div class="pt-4 border-t border-slate-50 dark:border-slate-800 flex items-center justify-between">
          <p class="text-slate-400 dark:text-slate-500 text-sm italic">
            {{ t('last_updated') }}: {{ new Date().toLocaleDateString() }}
          </p>
          <button 
            type="submit" 
            :disabled="saving"
            class="bg-indigo-600 text-white px-10 py-4 rounded-2xl font-bold hover:bg-indigo-700 transition-all shadow-lg shadow-indigo-100 disabled:opacity-70 flex items-center gap-3 active:scale-95"
          >
            <fa v-if="saving" icon="cog" class="animate-spin" />
            <fa v-else-if="saved" icon="check-circle" />
            <span>{{ saving ? t('saving_changes') : (saved ? t('profile_updated') : t('save_progress')) }}</span>
          </button>
        </div>
      </form>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      <div class="bg-rose-50 dark:bg-rose-950 border border-rose-100 dark:border-rose-900 rounded-3xl p-8">
        <h3 class="text-rose-900 dark:text-rose-300 font-bold text-lg mb-4 flex items-center gap-3">
          <fa icon="lock" />
          {{ t('security_access') }}
        </h3>
        <p class="text-rose-700 dark:text-rose-400 text-sm leading-relaxed mb-6">
          {{ t('security_msg') }}
        </p>
        <button class="bg-white dark:bg-slate-800 text-rose-600 dark:text-rose-400 px-6 py-3 rounded-xl font-bold border border-rose-200 dark:border-rose-900 hover:bg-rose-100 dark:hover:bg-slate-700 transition-colors">{{ t('audit_logic') }}</button>
      </div>

      <div class="bg-indigo-900 dark:bg-indigo-950 rounded-3xl p-8 text-white relative overflow-hidden">
        <div class="absolute -right-10 -bottom-10 opacity-10">
          <fa icon="cog" class="text-[150px]" />
        </div>
        <h3 class="font-bold text-xl mb-4">{{ t('system_integration') }}</h3>
        <p class="text-indigo-200 dark:text-indigo-300 text-sm mb-6">{{ t('integration_msg') }}</p>
        <button class="bg-white/10 hover:bg-white/20 dark:bg-white/5 dark:hover:bg-white/10 text-white px-6 py-3 rounded-xl font-bold border border-white/20 dark:border-white/10 backdrop-blur-sm transition-all">{{ t('developer_portal') }}</button>
      </div>
    </div>
  </div>
</template>
