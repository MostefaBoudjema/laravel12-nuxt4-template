<script lang="ts">
import { defineComponent, watch, onBeforeUnmount } from 'vue'

type ModalSize = 'sm' | 'md' | 'lg' | 'xl'

export default defineComponent({
  name: 'UiModal',
  props: {
    modelValue: { type: Boolean, required: true },
    title: { type: String, default: '' },
    size: { type: String as () => ModalSize, default: 'md' },
    closeOnBackdrop: { type: Boolean, default: true },
    closeOnEsc: { type: Boolean, default: true },
    showClose: { type: Boolean, default: true },
  },
  emits: ['update:modelValue', 'close'],
  setup(props, { emit }) {
    const panelSizes: Record<ModalSize, string> = {
      sm: 'max-w-sm',
      md: 'max-w-lg',
      lg: 'max-w-2xl',
      xl: 'max-w-4xl',
    }

    const close = () => {
      emit('update:modelValue', false)
      emit('close')
    }

    const onBackdrop = () => {
      if (props.closeOnBackdrop) close()
    }

    const onKeydown = (e: KeyboardEvent) => {
      if (!props.closeOnEsc) return
      if (e.key === 'Escape') close()
    }

    watch(
      () => props.modelValue,
      (open) => {
        if (typeof window === 'undefined') return
        document.documentElement.classList.toggle('overflow-hidden', open)
      },
      { immediate: true },
    )

    onBeforeUnmount(() => {
      if (typeof window === 'undefined') return
      document.documentElement.classList.remove('overflow-hidden')
    })

    return {
      panelSizes,
      close,
      onBackdrop,
      onKeydown,
    }
  },
})
</script>

<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition ease-out duration-150"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition ease-in duration-100"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="modelValue"
        class="fixed inset-0 z-50"
        role="dialog"
        aria-modal="true"
        @keydown="onKeydown"
      >
        <div
          class="absolute inset-0 bg-black/40 backdrop-blur-[2px]"
          @click="onBackdrop"
        />

        <div class="absolute inset-0 overflow-y-auto">
          <div class="min-h-full flex items-center justify-center p-4">
            <Transition
              enter-active-class="transition ease-out duration-150"
              enter-from-class="opacity-0 translate-y-2 scale-[0.98]"
              enter-to-class="opacity-100 translate-y-0 scale-100"
              leave-active-class="transition ease-in duration-100"
              leave-from-class="opacity-100 translate-y-0 scale-100"
              leave-to-class="opacity-0 translate-y-2 scale-[0.98]"
            >
              <div
                class="w-full rounded-2xl bg-white dark:bg-slate-900 border border-black/5 dark:border-white/10 shadow-2xl"
                :class="panelSizes[size]"
                @click.stop
              >
                <div v-if="title || $slots.header || showClose" class="px-5 pt-5">
                  <div class="flex items-start gap-4">
                    <div class="flex-1 min-w-0">
                      <slot name="header">
                        <h2 v-if="title" class="text-lg font-bold text-slate-900 dark:text-slate-100">
                          {{ title }}
                        </h2>
                      </slot>
                    </div>

                    <button
                      v-if="showClose"
                      type="button"
                      class="shrink-0 rounded-lg p-2 text-slate-500 hover:bg-slate-100 hover:text-slate-700 dark:text-slate-300 dark:hover:bg-white/10 dark:hover:text-white transition-colors"
                      aria-label="Close"
                      @click="close"
                    >
                      <span class="text-xl leading-none">×</span>
                    </button>
                  </div>
                </div>

                <div class="px-5 py-5">
                  <slot />
                </div>

                <div v-if="$slots.footer" class="px-5 pb-5">
                  <slot name="footer" />
                </div>
              </div>
            </Transition>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

