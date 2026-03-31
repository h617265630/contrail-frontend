import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './assets/tailwind.css'
import { installAnalytics } from './utils/analytics'
import { installSeo } from './utils/seo'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
installAnalytics(router)
installSeo(router)
app.use(router)
app.mount('#app')
