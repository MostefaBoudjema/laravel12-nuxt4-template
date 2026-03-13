import { library, config } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { 
  faUser, 
  faLock, 
  faSignOutAlt, 
  faDashboard, 
  faUsers, 
  faChartBar, 
  faCog,
  faExclamationTriangle,
  faCheckCircle,
  faSun,
  faMoon,
  faChevronDown,
  faBars,
  faTimes,
  faPlus,
  faEdit,
  faTrash,
  faShieldAlt,
  faKey,
  faSync
} from '@fortawesome/free-solid-svg-icons'

// This is important, we are going to let Nuxt handle the CSS
config.autoAddCss = false

library.add(
  faUser, 
  faLock, 
  faSignOutAlt, 
  faDashboard, 
  faUsers, 
  faChartBar, 
  faCog,
  faExclamationTriangle,
  faCheckCircle,
  faSun,
  faMoon,
  faChevronDown,
  faBars,
  faTimes,
  faPlus,
  faEdit,
  faTrash,
  faShieldAlt,
  faKey,
  faSync
)

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.component('fa', FontAwesomeIcon)
})
