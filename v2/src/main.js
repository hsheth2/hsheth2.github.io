import Vue from 'vue'
import Global from './Global.vue'

Vue.config.productionTip = false

new Vue({
  render: h => h(Global),
}).$mount('#app')
