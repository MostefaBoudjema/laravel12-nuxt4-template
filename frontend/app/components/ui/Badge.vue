<script lang="ts">
import { computed, defineComponent } from 'vue'

type BadgeVariant = 'default' | 'primary' | 'success' | 'warning' | 'danger'
type BadgeSize = 'sm' | 'md'

export default defineComponent({
  name: 'UiBadge',
  props: {
    variant: { type: String as () => BadgeVariant, default: 'default' },
    size: { type: String as () => BadgeSize, default: 'md' },
  },
  setup(props) {
    const variants: Record<BadgeVariant, string> = {
      default: 'bg-slate-100 text-slate-700 dark:bg-white/10 dark:text-slate-200',
      primary:
        'bg-purple-600/10 text-purple-700 dark:bg-purple-400/10 dark:text-purple-300',
      success:
        'bg-emerald-600/10 text-emerald-700 dark:bg-emerald-400/10 dark:text-emerald-300',
      warning: 'bg-amber-600/10 text-amber-800 dark:bg-amber-400/10 dark:text-amber-300',
      danger: 'bg-rose-600/10 text-rose-700 dark:bg-rose-400/10 dark:text-rose-300',
    }

    const sizes: Record<BadgeSize, string> = {
      sm: 'h-5 px-2 text-[11px]',
      md: 'h-6 px-2.5 text-xs',
    }

    const classes = computed(() =>
      [
        'inline-flex items-center rounded-full font-semibold',
        sizes[props.size],
        variants[props.variant],
      ]
        .filter(Boolean)
        .join(' '),
    )

    return { classes }
  },
})
</script>

<template>
  <span :class="classes">
    <slot />
  </span>
</template>

