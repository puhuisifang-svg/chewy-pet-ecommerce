<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup>
</script>

<style>
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --primary: #3b82f6;
  --primary-hover: #2563eb;
  --accent: #f59e0b;
  --text: #f1f5f9;
  --text-muted: #94a3b8;
  --bg: #0f172a;
  --surface: #1e293b;
  --border: #334155;
  --radius: 8px;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: var(--bg);
  color: var(--text);
  line-height: 1.6;
}

a { text-decoration: none; color: inherit; }
</style>
