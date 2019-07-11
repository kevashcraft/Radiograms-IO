import Vue from 'vue'
import App from './App.vue'

// Vue Material
import { MdButton, MdContent, MdField, MdList, MdMenu, MdSwitch } from 'vue-material/dist/components'
import { MdCard, MdChips, MdDialog, MdDrawer, MdIcon, MdSnackbar, MdToolbar } from 'vue-material/dist/components'
import 'vue-material/dist/vue-material.min.css'

import './styles/main.scss'
Vue.use(MdButton)
Vue.use(MdCard)
Vue.use(MdChips)
Vue.use(MdContent)
Vue.use(MdDialog)
Vue.use(MdField)
Vue.use(MdIcon)
Vue.use(MdList)
Vue.use(MdMenu)
Vue.use(MdSnackbar)
Vue.use(MdSwitch)

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')
