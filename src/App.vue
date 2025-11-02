<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

/**
 * --------------------------
 * Données éditables
 * --------------------------
 */

// Section Présentation
const hero = {
  name: 'Thibaud Maciuk',
  tagline:
    'Ingénieur backend — je conçois des APIs robustes, performantes et sécurisées pour des produits qui scalent.',
  subtitle:
    'Laravel, Node, Docker, sécurité, intégrations tierces, bases de données et perf.'
}

// Projets (cartes + modales)
const projects = ref([
  {
    id: 'nebula',
    title: 'Nebula Engine',
    summary: 'Meta-scanner de dépôts (Laravel + Rust) avec pipeline d’analyse.',
    tags: ['web', 'saas', 'rust', 'laravel'],
    details:
      'Nebula Engine scanne des dépôts Git à grande échelle et extrait des dépendances, licences et métadonnées. Stack: Laravel + PostgreSQL, Rust worker pour la partie parsing AST, Docker multi-services, CI/CD.',
  },
  {
    id: 'kiroshi',
    title: 'Kiroshi',
    summary: 'Agrégateur de marketplaces seconde main (recherche & alertes).',
    tags: ['web', 'saas', 'scraping'],
    details:
      'Comparateur / agrégateur de prix (Vinted, Leboncoin, eBay…). Moteur d’alertes, scoring, dashboards. APIs sécurisées, files d’attente, stockage durable.',
  },
  {
    id: 'lumen',
    title: 'Lumen (assistant local)',
    summary: 'Assistant IA local (Ollama + n8n) connecté aux notes.',
    tags: ['ia', 'self-hosted', 'automation'],
    details:
      'Assistant vocal/texte auto-hébergé avec modèles locaux via Ollama, orchestrations n8n, intégration notes Markdown, wake word, TTS fr de qualité.',
  },
])

// Timeline : modifie / ajoute facilement ici
const timeline = ref([
  {
    date: '2025 — présent',
    title: 'Freelance Backend / DevOps',
    description:
      'Conception d’APIs, intégrations tierces, observabilité, sécurité, déploiements Docker/K8s.',
  },
  {
    date: '2023 — 2025',
    title: 'Développeur Backend',
    description:
      'SaaS B2B, forte volumétrie, optimisation SQL, files d’attente, résilience & monitoring.',
  },
  {
    date: '2021 — 2023',
    title: 'Développeur Web',
    description:
      'Applications web, automatisations, CI/CD, bonnes pratiques d’architecture.',
  },
])

/**
 * --------------------------
 * État UI & logique
 * --------------------------
 */

// Modale projet
const openProjectId = ref(null)
const openProject = (id) => { openProjectId.value = id }
const closeProject = () => { openProjectId.value = null }

// Nav active selon la section visible
const sections = ['presentation', 'projects', 'about', 'timeline']
const activeSection = ref('presentation')
let observer

onMounted(() => {
  // Observe les sections pour surligner le lien actif dans le header
  const opts = { root: null, rootMargin: '0px', threshold: 0.6 }
  observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) activeSection.value = entry.target.id
    })
  }, opts)

  sections.forEach((id) => {
    const el = document.getElementById(id)
    if (el) observer.observe(el)
  })

  // Écouteur échap pour fermer la modale
  window.addEventListener('keydown', onKeyDown)
})

onBeforeUnmount(() => {
  if (observer) observer.disconnect()
  window.removeEventListener('keydown', onKeyDown)
})

function onKeyDown(e) {
  if (e.key === 'Escape') closeProject()
}

// Scroll lisse vers une ancre
const goTo = (id) => {
  const el = document.getElementById(id)
  if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
}
</script>

<template>
  <div class="app">
    <!-- Header sticky -->
    <header class="header">
      <div class="header__inner">
        <div class="brand" @click="goTo('presentation')">Thibaud<span class="dot">.</span></div>
        <nav class="nav">
          <button
            v-for="s in sections"
            :key="s"
            class="nav__link"
            :class="{ 'is-active': activeSection === s }"
            @click="goTo(s)"
          >
            {{ s === 'presentation' ? 'Présentation' :
               s === 'projects' ? 'Projets' :
               s === 'about' ? 'À propos' : 'Timeline' }}
          </button>
        </nav>
      </div>
    </header>

    <!-- Présentation -->
    <section id="presentation" class="section section--hero">
      <div class="container">
        <h1 class="hero__title">
          {{ hero.tagline }}
        </h1>
        <p class="hero__name">
          {{ hero.name }}
        </p>
        <p class="hero__subtitle">
          {{ hero.subtitle }}
        </p>
        <div class="hero__cta">
          <button class="btn btn--action" @click="goTo('projects')">Voir mes projets</button>
          <button class="btn btn--ghost" @click="goTo('about')">En savoir plus</button>
        </div>
      </div>
    </section>

    <!-- Projets -->
    <section id="projects" class="section">
      <div class="container">
        <h2 class="section__title">Projets</h2>

        <div class="projects">
          <article
            v-for="p in projects"
            :key="p.id"
            class="project-card"
          >
            <div class="project-card__header">
              <h3 class="project-card__title">{{ p.title }}</h3>
              <ul class="project-card__tags">
                <li v-for="t in p.tags" :key="t" class="tag">#{{ t }}</li>
              </ul>
            </div>
            <p class="project-card__summary">{{ p.summary }}</p>
            <div class="project-card__actions">
              <button class="btn btn--action" @click="openProject(p.id)">Détails</button>
            </div>
          </article>
        </div>
      </div>
    </section>

    <!-- Modale Projet -->
    <div
      v-if="openProjectId"
      class="modal"
      role="dialog"
      aria-modal="true"
      @click.self="closeProject"
    >
      <div class="modal__content">
        <button class="modal__close" @click="closeProject" aria-label="Fermer">×</button>
        <template v-for="p in projects" :key="p.id">
          <div v-if="p.id === openProjectId">
            <h3 class="modal__title">{{ p.title }}</h3>
            <ul class="modal__tags">
              <li v-for="t in p.tags" :key="t" class="tag">#{{ t }}</li>
            </ul>
            <p class="modal__text">{{ p.details }}</p>
          </div>
        </template>
      </div>
    </div>

    <!-- À propos -->
    <section id="about" class="section">
      <div class="container">
        <h2 class="section__title">À propos</h2>
        <div class="about">
          <p>
            Ingénieur backend basé en France, je construis des APIs fiables, sécurisées et
            performantes. J’aime les architectures claires, la robustesse en production
            (observabilité, logs, alerting), et les pipelines DevOps bien huilés.
          </p>
          <p>
            Mes terrains de jeu : Laravel/PHP, Node, bases de données (PostgreSQL, Redis),
            files d’attente, Docker, sécurité applicative et intégrations tierces.
          </p>
        </div>
      </div>
    </section>

    <!-- Timeline -->
    <section id="timeline" class="section">
      <div class="container">
        <h2 class="section__title">Timeline</h2>

        <ol class="timeline">
          <li v-for="(item, idx) in timeline" :key="idx" class="timeline__item">
            <div class="timeline__dot"></div>
            <div class="timeline__content">
              <div class="timeline__date">{{ item.date }}</div>
              <div class="timeline__title">{{ item.title }}</div>
              <div class="timeline__desc">{{ item.description }}</div>
            </div>
          </li>
        </ol>
      </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
      <div class="container footer__inner">
        <div class="footer__left">© {{ new Date().getFullYear() }} Thibaud.</div>
        <div class="footer__actions">
          <a class="btn btn--soft" href="mailto:contact@thibaud.tech">Email</a>
          <a class="btn btn--soft" href="/cv.pdf" download>CV</a>
          <a class="btn btn--soft" href="https://github.com/thibaud" target="_blank" rel="noopener">GitHub</a>
          <a class="btn btn--soft" href="https://www.linkedin.com/in/thibaud" target="_blank" rel="noopener">LinkedIn</a>
        </div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
/* --------------------------
   Variables / Reset
--------------------------- */
:root{
  --primary:#E5E5E5;
  --secondary:#999999;
  --action:#006AFF;
  --good:#00B33C;
  --bad:#E6192A;
  --surface1:#333333;
  --surface2:#1A1A1A;
  --background:#262626;
  --backgroundTranslucent:#000000a6;
}

*{ box-sizing:border-box; }
html, body, #app{ height:100%; }
html{ scroll-behavior:smooth; }
body{
  margin:0;
  font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
  color: var(--primary);
  background: var(--background);
  line-height: 1.6;
}

.app{ display:flex; flex-direction:column; min-height:100dvh; }
.container{ width:100%; max-width:1140px; margin:0 auto; padding:0 16px; }

/* --------------------------
   Header
--------------------------- */
.header{
  position: sticky;
  top: 0;
  z-index: 50;
  background: color-mix(in srgb, var(--background) 85%, transparent);
  backdrop-filter: blur(6px);
  border-bottom: 1px solid rgba(255,255,255,0.06);
}
.header__inner{
  height:64px;
  display:flex;
  align-items:center;
  justify-content:space-between;
}
.brand{
  font-weight:700;
  letter-spacing:0.2px;
  cursor:pointer;
}
.brand .dot{ color: var(--action); }
.nav{ display:flex; gap:8px; }
.nav__link{
  background: transparent;
  color: var(--secondary);
  border: 1px solid transparent;
  padding:8px 12px;
  border-radius:10px;
  cursor:pointer;
  transition: all .2s ease;
}
.nav__link:hover{
  color: var(--primary);
  border-color: rgba(255,255,255,.12);
  background: rgba(255,255,255,.03);
}
.nav__link.is-active{
  color: var(--primary);
  border-color: rgba(255,255,255,.16);
  background: rgba(255,255,255,.06);
}

/* --------------------------
   Sections
--------------------------- */
.section{ padding:64px 0; }
.section__title{
  font-size:28px;
  font-weight:700;
  margin:0 0 24px 0;
}

/* Hero */
.section--hero{
  padding:96px 0 64px;
  background:
    radial-gradient(800px 400px at 10% -10%, rgba(0,106,255,0.15), transparent 60%),
    radial-gradient(600px 300px at 90% -20%, rgba(255,255,255,0.08), transparent 60%);
}
.hero__title{
  font-size: clamp(24px, 5vw, 34px);
  font-weight: 700;
  margin: 0 0 12px;
  color: var(--primary);
}
.hero__name{
  font-size: clamp(28px, 6vw, 42px);
  font-weight: 800;
  margin: 0 0 8px;
  color: var(--primary);
}
.hero__subtitle{
  color: var(--secondary);
  margin: 0 0 20px;
}
.hero__cta{ display:flex; gap:12px; flex-wrap:wrap; }

/* Boutons génériques */
.btn{
  appearance:none;
  border:none;
  border-radius:12px;
  padding:10px 16px;
  font-weight:600;
  cursor:pointer;
  transition: transform .15s ease, background .2s ease, color .2s ease, border-color .2s ease;
}
.btn:active{ transform: translateY(1px); }
.btn--action{
  color:#fff;
  background: var(--action);
}
.btn--action:hover{
  background: color-mix(in srgb, var(--action) 80%, #ffffff 20%);
}
.btn--ghost{
  color: var(--primary);
  background: transparent;
  border:1px solid rgba(255,255,255,.18);
}
.btn--ghost:hover{
  background: rgba(255,255,255,.08);
}

/* --------------------------
   Projets (cards + modale)
--------------------------- */
.projects{
  display:grid;
  gap:16px;
  grid-template-columns: repeat(1, 1fr);
}
@media (min-width: 640px){
  .projects{ grid-template-columns: repeat(2, 1fr); }
}
@media (min-width: 960px){
  .projects{ grid-template-columns: repeat(3, 1fr); }
}
.project-card{
  border: 1px solid rgba(255,255,255,.08);
  background: var(--surface2);
  border-radius: 14px;
  padding: 16px;
  display:flex;
  flex-direction:column;
  gap:10px;
  transition: transform .15s ease, box-shadow .2s ease, border-color .2s ease;
  box-shadow: 0 6px 20px rgba(0,0,0,.18);
}
.project-card:hover{
  transform: translateY(-2px);
  border-color: rgba(255,255,255,.16);
  box-shadow: 0 10px 26px rgba(0,0,0,.26);
}
.project-card__header{
  display:flex; align-items:flex-start; justify-content:space-between; gap:8px;
}
.project-card__title{
  margin:0; font-size:18px; font-weight:700; color: var(--primary);
}
.project-card__tags{
  margin:0; padding:0; list-style:none; display:flex; flex-wrap:wrap; gap:6px;
}
.tag{
  font-size:12px; color: var(--primary);
  border:1px solid rgba(255,255,255,.14);
  padding:4px 8px; border-radius:999px;
  background: rgba(255,255,255,.03);
}
.project-card__summary{
  color: var(--secondary); margin:0;
}
.project-card__actions{ margin-top:auto; display:flex; gap:8px; }

/* Modale */
.modal{
  position: fixed; inset:0; display:flex; align-items:center; justify-content:center;
  background: var(--backgroundTranslucent);
  padding: 20px;
  z-index: 100;
}
.modal__content{
  width:100%; max-width:720px;
  background: var(--surface1);
  border:1px solid rgba(255,255,255,.12);
  border-radius:16px;
  padding:20px 20px 24px;
  position: relative;
  box-shadow: 0 30px 80px rgba(0,0,0,.35);
}
.modal__close{
  position:absolute; top:10px; right:12px;
  width:36px; height:36px; border-radius:8px;
  border:1px solid rgba(255,255,255,.12);
  background: rgba(255,255,255,.04);
  color: var(--primary);
  font-size:20px; line-height:1;
  cursor:pointer;
}
.modal__title{ margin:4px 0 8px; font-weight:800; font-size:22px; }
.modal__tags{ margin:0 0 10px; padding:0; list-style:none; display:flex; gap:6px; flex-wrap: wrap; }
.modal__text{ color: var(--primary); }

/* --------------------------
   About
--------------------------- */
.about{
  display:grid; gap:12px;
  color: var(--primary);
}
.about p{ margin:0; color: var(--primary); }
.about p + p{ color: var(--secondary); }

/* --------------------------
   Timeline
--------------------------- */
.timeline{
  position:relative;
  list-style:none;
  margin:24px 0 0; padding:0 0 0 24px;
}
.timeline::before{
  content:""; position:absolute; left:10px; top:0; bottom:0;
  width:2px; background: rgba(255,255,255,.12);
}
.timeline__item{ position:relative; margin-bottom:20px; }
.timeline__dot{
  position:absolute; left:-1px; top:6px; width:14px; height:14px; border-radius:50%;
  background: var(--action);
  border: 2px solid var(--surface2);
  box-shadow: 0 0 0 3px rgba(0,106,255,.25);
}
.timeline__content{
  background: var(--surface2);
  border:1px solid rgba(255,255,255,.1);
  border-radius:12px;
  padding:12px 14px;
}
.timeline__date{ color: var(--secondary); font-size:12px; margin-bottom:4px; }
.timeline__title{ font-weight:700; margin-bottom:4px; color: var(--primary); }
.timeline__desc{ color: var(--primary); }

/* --------------------------
   Footer
--------------------------- */
.footer{
  margin-top:auto;
  padding:18px 0;
  border-top:1px solid rgba(255,255,255,.08);
  background: var(--surface2);
}
.footer__inner{
  display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap: wrap;
}
.footer__left{ color: var(--secondary); font-size:14px; }
.footer__actions{ display:flex; gap:8px; flex-wrap: wrap; }
.btn--soft{
  background: rgba(255,255,255,.06);
  color: var(--primary);
  border:1px solid rgba(255,255,255,.12);
}
.btn--soft:hover{
  background: rgba(255,255,255,.12);
}

/* --------------------------
   Responsiveness
--------------------------- */
@media (max-width: 740px){
  .header__inner{ height:56px; }
  .nav{ gap:4px; }
  .nav__link{ padding:6px 10px; font-size:14px; }
  .section{ padding:48px 0; }
  .modal__content{ padding:16px; }
}
</style>
