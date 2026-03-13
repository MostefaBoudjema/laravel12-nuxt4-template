<script setup lang="ts">
definePageMeta({
  layout: 'default'
})
const { t } = useI18n()
</script>

<template>
  <div class="flex flex-col items-center justify-center min-h-[60vh] text-center px-4">
    <div class="w-24 h-24 bg-rose-500/20 rounded-full flex items-center justify-center text-rose-500 mb-8 border border-rose-500/30 animate-pulse">
      <fa icon="exclamation-triangle" class="text-4xl" />
    </div>
    
    <h1 class="text-6xl font-black mb-4 bg-clip-text text-transparent bg-gradient-to-r from-rose-400 to-rose-600">403</h1>
    <h2 class="text-3xl font-bold mb-6">{{ t('unauthorized_access') }}</h2>
    <p class="text-white/60 max-w-md text-lg leading-relaxed mb-10">
      {{ t('unauthorized_msg') }}
    </p>
    
    <div class="flex gap-4">
      <NuxtLink to="/" class="px-8 py-4 bg-white text-indigo-900 font-bold rounded-2xl hover:bg-white/90 transition-all shadow-xl active:scale-95">
        {{ t('back_to_dashboard') }}
      </NuxtLink>
      <button @click="$router.back()" class="px-8 py-4 bg-white/5 border border-white/10 text-white font-bold rounded-2xl hover:bg-white/10 transition-all active:scale-95">
        {{ t('go_back') }}
      </button>
    </div>
  </div>
</template>
