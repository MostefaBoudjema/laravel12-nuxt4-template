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
    <UiCard class="!p-10">
      <div class="flex items-start gap-8 border-b border-slate-50 dark:border-slate-800 pb-10 mb-10">
        <div class="w-32 h-32 rounded-3xl bg-gradient-to-tr from-indigo-500 to-indigo-700 flex items-center justify-center text-5xl text-white font-black shadow-xl shadow-indigo-100 dark:shadow-indigo-900/50">
          {{ auth.user?.name.charAt(0) }}
        </div>
        <div>
          <h2 class="text-3xl font-bold text-slate-800 dark:text-slate-200 mb-2">{{ auth.user?.name }}</h2>
          <p class="text-slate-500 dark:text-slate-400 mb-4">{{ auth.user?.email }}</p>
          <div class="flex gap-2">
            <UiBadge v-for="role in auth.user?.roles" :key="role" variant="primary">
              {{ role }}
            </UiBadge>
          </div>
        </div>
      </div>

      <form @submit.prevent="handleSave" class="space-y-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <UiInput
            v-model="form.name"
            id="settings-name"
            type="text"
            :label="t('display_name')"
            size="lg"
          />
          <UiInput
            v-model="form.email"
            id="settings-email"
            type="email"
            :label="t('email_address')"
            size="lg"
          />
        </div>

        <div class="pt-4 border-t border-slate-50 dark:border-slate-800 flex items-center justify-between">
          <p class="text-slate-400 dark:text-slate-500 text-sm italic">
            {{ t('last_updated') }}: {{ new Date().toLocaleDateString() }}
          </p>
          <UiButton type="submit" :loading="saving" :disabled="saving" size="lg">
            <fa v-if="saved" icon="check-circle" />
            {{ saving ? t('saving_changes') : (saved ? t('profile_updated') : t('save_progress')) }}
          </UiButton>
        </div>
      </form>
    </UiCard>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      <UiAlert variant="danger" :dismissible="false">
        <template #default>
          <h3 class="text-rose-900 dark:text-rose-300 font-bold text-lg mb-4 flex items-center gap-3">
            <fa icon="lock" />
            {{ t('security_access') }}
          </h3>
          <p class="text-rose-700 dark:text-rose-400 text-sm leading-relaxed mb-6">
            {{ t('security_msg') }}
          </p>
          <UiButton variant="secondary" size="sm">{{ t('audit_logic') }}</UiButton>
        </template>
      </UiAlert>

      <div class="bg-indigo-900 dark:bg-indigo-950 rounded-3xl p-8 text-white relative overflow-hidden">
        <div class="absolute -right-10 -bottom-10 opacity-10">
          <fa icon="cog" class="text-[150px]" />
        </div>
        <h3 class="font-bold text-xl mb-4">{{ t('system_integration') }}</h3>
        <p class="text-indigo-200 dark:text-indigo-300 text-sm mb-6">{{ t('integration_msg') }}</p>
        <UiButton variant="ghost" size="sm" class="!text-white !border-white/20 !bg-white/10 hover:!bg-white/20">
          {{ t('developer_portal') }}
        </UiButton>
      </div>
    </div>
  </div>
</template>
<style>

.router-link-active:not(#logout) {
  @apply bg-indigo-600 text-white shadow-lg shadow-indigo-500/20 dark:shadow-none;
}
</style>