<script lang="ts">
import { computed, defineComponent, resolveComponent } from 'vue'

type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger'
type ButtonSize = 'sm' | 'md' | 'lg'

export default defineComponent({
  name: 'UiButton',
  props: {
    variant: { type: String as () => ButtonVariant, default: 'primary' },
    size: { type: String as () => ButtonSize, default: 'md' },
    block: { type: Boolean, default: false },
    loading: { type: Boolean, default: false },
    disabled: { type: Boolean, default: false },
    type: { type: String as () => 'button' | 'submit' | 'reset', default: 'button' },
    to: { type: [String, Object] as any, default: null },
    href: { type: String, default: null },
    target: { type: String, default: null },
    rel: { type: String, default: null },
  },
  emits: ['click'],
  setup(props, { emit }) {
    const isLink = computed(() => Boolean(props.to || props.href))
    const isDisabled = computed(() => props.disabled || props.loading)

    const base =
      'inline-flex items-center justify-center gap-2 rounded-xl font-semibold transition-all select-none focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-purple-500 focus-visible:ring-offset-white dark:focus-visible:ring-offset-slate-900'

    const sizes: Record<ButtonSize, string> = {
      sm: 'h-9 px-3 text-sm',
      md: 'h-10 px-4 text-sm',
      lg: 'h-11 px-5 text-base',
    }

    const variants: Record<ButtonVariant, string> = {
      primary:
        'bg-slate-900 text-white hover:bg-slate-800 active:bg-slate-900/90 dark:bg-white dark:text-slate-900 dark:hover:bg-slate-200',
      secondary:
        'bg-white text-slate-900 border border-slate-200 hover:bg-slate-50 active:bg-slate-100 dark:bg-slate-800 dark:text-slate-100 dark:border-white/10 dark:hover:bg-slate-700/70',
      ghost:
        'bg-transparent text-slate-700 hover:bg-slate-100 active:bg-slate-200/70 dark:text-slate-200 dark:hover:bg-white/10 dark:active:bg-white/15',
      danger:
        'bg-rose-600 text-white hover:bg-rose-500 active:bg-rose-600/90 dark:bg-rose-500 dark:hover:bg-rose-400',
    }

    const classes = computed(() => {
      const disabled = isDisabled.value
        ? 'opacity-60 cursor-not-allowed pointer-events-none'
        : 'cursor-pointer'

      return [
        base,
        sizes[props.size],
        variants[props.variant],
        disabled,
        props.block ? 'w-full' : '',
      ]
        .filter(Boolean)
        .join(' ')
    })

    const componentTag = computed(() => {
      if (props.to) return resolveComponent('NuxtLink')
      if (props.href) return 'a'
      return 'button'
    })

    const computedRel = computed(() => {
      if (!props.href || !props.target) return props.rel ?? null
      if (props.target !== '_blank') return props.rel ?? null
      return props.rel ?? 'noopener noreferrer'
    })

    const onClick = (evt: MouseEvent) => emit('click', evt)

    return {
      isLink,
      isDisabled,
      classes,
      componentTag,
      computedRel,
      onClick,
    }
  },
})
</script>

<template>
  <component
    :is="componentTag"
    :class="classes"
    :disabled="!isLink ? isDisabled : undefined"
    :type="!isLink ? type : undefined"
    :to="to || undefined"
    :href="href || undefined"
    :target="target || undefined"
    :rel="computedRel || undefined"
    @click="onClick"
  >
    <span
      v-if="loading"
      class="inline-block h-4 w-4 rounded-full border-2 border-current border-b-transparent animate-spin"
      aria-hidden="true"
    />
    <slot />
  </component>
</template>

