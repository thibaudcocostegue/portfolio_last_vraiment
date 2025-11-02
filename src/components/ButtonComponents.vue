<script setup>
import { computed } from 'vue'

const props = defineProps({
  label: { type: String, required: true },
  to: { type: String, required: true },
})

const isExternal = computed(() =>
  props.to.startsWith('http') || props.to.startsWith('#')
)
</script>

<template>
  <component
    :is="isExternal ? 'a' : 'router-link'"
    :to="!isExternal ? to : undefined"
    :href="isExternal ? to : undefined"
    target="_blank"
    rel="noopener"
    class="base-button"
  >
    {{ label }}
  </component>
</template>

<style scoped lang="scss">
.base-button {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  border-radius: 16px;
  font-weight: 500;
  font-size: 1rem;
  color: #ffffff;
  background: transparent;
//   border: 1px solid rgba(255, 255, 255, 0.15);
  text-decoration: none;
  transition: all 0.3s ease;
  cursor: pointer;

  &:hover {
    background: rgba(255, 255, 255, 0.16);
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(9.2px);
    -webkit-backdrop-filter: blur(9.2px);
    // border: 1px solid rgba(255, 255, 255, 0.3);
    transform: translateY(-2px);
  }

  &:active {
    transform: translateY(0);
    backdrop-filter: blur(5px);
    -webkit-backdrop-filter: blur(5px);
  }

  &:focus {
    outline: 2px solid rgba(255, 255, 255, 0.4);
    outline-offset: 2px;
  }
}
</style>
