<script lang="ts">
import { computed, defineComponent } from 'vue'

type InputSize = 'sm' | 'md' | 'lg'

export default defineComponent({
  name: 'UiInput',
  props: {
    modelValue: { type: [String, Number] as any, default: '' },
    label: { type: String, default: '' },
    hint: { type: String, default: '' },
    error: { type: String, default: '' },
    type: { type: String, default: 'text' },
    placeholder: { type: String, default: '' },
    disabled: { type: Boolean, default: false },
    readonly: { type: Boolean, default: false },
    id: { type: String, default: undefined },
    name: { type: String, default: undefined },
    autocomplete: { type: String, default: undefined },
    size: { type: String as () => InputSize, default: 'md' },
  },
  emits: ['update:modelValue', 'blur', 'focus'],
  setup(props, { emit, slots }) {
    const sizes: Record<InputSize, string> = {
      sm: 'h-9 text-sm px-3',
      md: 'h-10 text-sm px-3.5',
      lg: 'h-11 text-base px-4',
    }

    const hasError = computed(() => Boolean(props.error))

    const inputClasses = computed(() => {
      const base =
        'w-full rounded-xl border bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 placeholder:text-slate-400 dark:placeholder:text-slate-500 shadow-sm outline-none transition-all'

      const border = hasError.value
        ? 'border-rose-300 dark:border-rose-500/50 focus:border-rose-500 focus:ring-2 focus:ring-rose-500/20'
        : 'border-slate-200 dark:border-white/10 focus:border-purple-500 focus:ring-2 focus:ring-purple-500/20'

      const disabled = props.disabled
        ? 'opacity-60 cursor-not-allowed bg-slate-50 dark:bg-slate-900/60'
        : ''

      const withIcons = slots.left || slots.right ? 'pl-10 pr-10' : ''

      return [base, sizes[props.size], border, disabled, withIcons]
        .filter(Boolean)
        .join(' ')
    })

    const describedBy = computed(() => {
      const ids: string[] = []
      if (props.id && props.hint) ids.push(`${props.id}-hint`)
      if (props.id && props.error) ids.push(`${props.id}-error`)
      return ids.length ? ids.join(' ') : undefined
    })

    const onInput = (evt: Event) => {
      const target = evt.target as HTMLInputElement | null
      emit('update:modelValue', target?.value ?? '')
    }

    const onBlur = (evt: FocusEvent) => emit('blur', evt)
    const onFocus = (evt: FocusEvent) => emit('focus', evt)

    return {
      hasError,
      inputClasses,
      describedBy,
      onInput,
      onBlur,
      onFocus,
    }
  },
})
</script>

<template>
  <div class="space-y-1.5">
    <label
      v-if="label"
      class="block text-sm font-semibold text-slate-700 dark:text-slate-200"
      :for="id"
    >
      {{ label }}
    </label>

    <div class="relative">
      <div
        v-if="$slots.left"
        class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3 text-slate-400 dark:text-slate-500"
      >
        <slot name="left" />
      </div>

      <input
        :id="id"
        :name="name"
        :type="type"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :autocomplete="autocomplete"
        :aria-invalid="hasError || undefined"
        :aria-describedby="describedBy"
        :class="inputClasses"
        :value="modelValue ?? ''"
        @input="onInput"
        @blur="onBlur"
        @focus="onFocus"
      />

      <div
        v-if="$slots.right"
        class="absolute inset-y-0 right-0 flex items-center pr-3 text-slate-400 dark:text-slate-500"
      >
        <slot name="right" />
      </div>
    </div>

    <p
      v-if="hint && !error"
      class="text-xs text-slate-500 dark:text-slate-400"
      :id="id ? `${id}-hint` : undefined"
    >
      {{ hint }}
    </p>

    <p
      v-if="error"
      class="text-xs text-rose-600 dark:text-rose-400"
      :id="id ? `${id}-error` : undefined"
    >
      {{ error }}
    </p>
  </div>
</template>

