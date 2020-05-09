<template>
  <App></App>
</template>

<script>
import Vue from 'vue'
import Buefy from 'buefy'

Vue.use(Buefy)

import App from "./components/App";

export default {
  name: 'Global',
  components: {
    App,
  }
}
</script>

<style lang="sass">
  // Import Bulma's core
  @import "~bulma/sass/utilities/_all"

  // Import Bulma and Buefy styles
  @import "~bulma"
  @import "~buefy/src/scss/buefy"
</style>