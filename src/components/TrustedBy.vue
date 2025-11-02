<script setup>
const companies = [
  { name: 'Kyxar', logo: '/logos/kyxar.png', alt: 'Kyxar' },
  { name: 'Freegun', logo: '/logos/freegun.png', alt: 'Freegun' },
  { name: 'Alain Milliat', logo: '/logos/alain-milliat.png', alt: 'Alain Milliat' },
  { name: 'Amazon', logo: '/logos/amazon.png', alt: 'Amazon' },
  { name: 'TotalEnergies', logo: '/logos/totalenergies.png', alt: 'TotalEnergies' },
  // ➕ Tu pourras facilement en ajouter d'autres ici
]
</script>

<template>
  <section class="trusted-by">
    <h2 class="title">Ils m’ont fait confiance</h2>
    <div class="logos">
      <div
        v-for="company in companies"
        :key="company.name"
        class="logo-item"
      >
        <img
          :src="company.logo"
          :alt="company.alt"
          :title="company.name"
          loading="lazy"
        />
      </div>
    </div>
  </section>
</template>

<style scoped lang="scss">
.trusted-by {
  text-align: center;
  padding: 4rem 2rem;
  background: var(--background);
  color: var(--primary);

  .title{
    color: #999999;
  }
  h2 {
    font-size: 1.8rem;
    margin-bottom: 2rem;
    letter-spacing: 0.5px;
  }

  .logos {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
    gap: 2rem;
    align-items: center;
    justify-items: center;
    margin-top: 1rem;
  }

  .logo-item {
    opacity: 0.8;
    transition: all 0.3s ease;
    filter: grayscale(100%) brightness(0.8);

    img {
      width: 50rem;
    //   max-width: 120px;
      height: auto;
      object-fit: contain;
      user-select: none;
    }

    &:hover {
      opacity: 1;
      filter: grayscale(0%) brightness(1);
      transform: scale(1.05);
    }
  }
}
</style>
