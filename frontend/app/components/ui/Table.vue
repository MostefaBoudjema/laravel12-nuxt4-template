<script lang="ts">
import { computed, defineComponent } from 'vue'

export default defineComponent({
  name: 'UiTable',
  props: {
    caption: { type: String, default: '' },
    striped: { type: Boolean, default: true },
    dense: { type: Boolean, default: false },
  },
  setup(props) {
    const cellPad = computed(() => (props.dense ? 'px-3 py-2' : 'px-4 py-3'))
    return { cellPad }
  },
})
</script>

<template>
  <div class="w-full overflow-x-auto rounded-2xl border border-slate-200 dark:border-white/10 bg-white dark:bg-slate-900 shadow-sm">
    <table class="min-w-full text-left text-sm">
      <caption v-if="caption" class="px-4 py-3 text-sm text-slate-600 dark:text-slate-300 text-left">
        {{ caption }}
      </caption>

      <thead class="bg-slate-50 dark:bg-white/5 text-slate-700 dark:text-slate-200">
        <tr>
          <slot name="head" :cellClass="cellPad" />
        </tr>
      </thead>

      <tbody class="divide-y divide-slate-100 dark:divide-white/10 text-slate-800 dark:text-slate-100">
        <slot name="body" :cellClass="cellPad" :striped="striped" />
      </tbody>
    </table>
  </div>
</template>

