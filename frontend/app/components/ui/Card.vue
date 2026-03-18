<script lang="ts">
import { computed, defineComponent } from 'vue'

type CardVariant = 'default' | 'muted' | 'outline'

export default defineComponent({
  name: 'UiCard',
  props: {
    variant: { type: String as () => CardVariant, default: 'default' },
    padded: { type: Boolean, default: true },
  },
  setup(props) {
    const variants: Record<CardVariant, string> = {
      default:
        'bg-white dark:bg-slate-900 border border-black/5 dark:border-white/10 shadow-sm',
      muted:
        'bg-slate-50 dark:bg-slate-900/60 border border-black/5 dark:border-white/10',
      outline: 'bg-transparent border border-slate-200 dark:border-white/10',
    }

    const classes = computed(() =>
      ['rounded-2xl', variants[props.variant], props.padded ? 'p-5' : '']
        .filter(Boolean)
        .join(' '),
    )

    return { classes }
  },
})
</script>

<template>
  <section :class="classes">
    <header v-if="$slots.header" class="mb-4">
      <slot name="header" />
    </header>

    <div>
      <slot />
    </div>

    <footer v-if="$slots.footer" class="mt-4">
      <slot name="footer" />
    </footer>
  </section>
</template>

