<template>
  <div class="hello">
    <h2>{{ message }}</h2>
  </div>
</template>

<script setup>
const message = 'Hello from a component!'
</script>

<style scoped>
.hello {
  text-align: center;
  color: #333;
  margin-top: 2rem;
}
</style>
