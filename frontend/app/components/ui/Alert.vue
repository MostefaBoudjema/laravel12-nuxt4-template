<script lang="ts">
import { defineComponent } from 'vue'

type AlertVariant = 'info' | 'success' | 'warning' | 'danger'

export default defineComponent({
  name: 'UiAlert',
  props: {
    modelValue: { type: Boolean, default: true },
    variant: { type: String as () => AlertVariant, default: 'info' },
    title: { type: String, default: '' },
    dismissible: { type: Boolean, default: false },
  },
  emits: ['update:modelValue', 'close'],
  setup(props, { emit }) {
    const styles: Record<AlertVariant, { wrap: string; title: string; body: string }> = {
      info: {
        wrap: 'bg-slate-50 border-slate-200 dark:bg-white/5 dark:border-white/10',
        title: 'text-slate-900 dark:text-slate-100',
        body: 'text-slate-700 dark:text-slate-200',
      },
      success: {
        wrap: 'bg-emerald-50 border-emerald-200 dark:bg-emerald-400/10 dark:border-emerald-400/20',
        title: 'text-emerald-950 dark:text-emerald-100',
        body: 'text-emerald-800 dark:text-emerald-200',
      },
      warning: {
        wrap: 'bg-amber-50 border-amber-200 dark:bg-amber-400/10 dark:border-amber-400/20',
        title: 'text-amber-950 dark:text-amber-100',
        body: 'text-amber-800 dark:text-amber-200',
      },
      danger: {
        wrap: 'bg-rose-50 border-rose-200 dark:bg-rose-400/10 dark:border-rose-400/20',
        title: 'text-rose-950 dark:text-rose-100',
        body: 'text-rose-800 dark:text-rose-200',
      },
    }

    const close = () => {
      emit('update:modelValue', false)
      emit('close')
    }

    return { styles, close }
  },
})
</script>

<template>
  <div
    v-if="modelValue"
    class="rounded-2xl border p-4"
    :class="styles[variant].wrap"
    role="alert"
  >
    <div class="flex gap-3">
      <div class="min-w-0 flex-1">
        <p v-if="title" class="text-sm font-bold" :class="styles[variant].title">
          {{ title }}
        </p>
        <div class="text-sm mt-0.5" :class="styles[variant].body">
          <slot />
        </div>
      </div>

      <button
        v-if="dismissible"
        type="button"
        class="shrink-0 rounded-lg p-2 -m-2 text-slate-500 hover:bg-black/5 dark:text-slate-300 dark:hover:bg-white/10 transition-colors"
        aria-label="Dismiss"
        @click="close"
      >
        <span class="text-lg leading-none">×</span>
      </button>
    </div>
  </div>
</template>

