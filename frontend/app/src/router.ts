import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'

// Lazy-loaded routes to avoid ReferenceError during HMR/initial load
const Home = () => import('./pages/Home.vue')
const LearningPathsList = () => import('./pages/MyLearningPath.vue')
const LearningPath = () => import('./pages/LearningPath.vue')
const Login = () => import('./pages/Login.vue')
const Register = () => import('./pages/Register.vue')
const ResourceLibrary = () => import('./pages/ResourceLibrary.vue')
const ResourceVideo = () => import('./pages/ResourceVideo.vue')
const ResourceDocument = () => import('./pages/ResourceDocument.vue')
const AddResourceToPath = () => import('./pages/AddResourceToPath.vue')
const MyResource = () => import('./pages/MyResource.vue')
const Partical = () => import('./pages/Partical.vue')
const LearningPathDetail = () => import('./pages/LearningPathDetail.vue')
const LearningPathLinear = () => import('./pages/LearningPathLinear.vue')
const LearningPoolCategory = () => import('./pages/LearningPoolCategory.vue')
const CreatePath = () => import('./pages/CreatePath.vue')
const LearningPathEdit = () => import('./pages/LearningPathEdit.vue')

const About = () => import('./pages/About.vue')
const Plan = () => import('./pages/Plan.vue')

const routes: RouteRecordRaw[] = [
  // Canonical routes
  { path: '/', redirect: { name: 'home' } },
  { path: '/home', name: 'home', component: Home },
  { path: '/learningpool', name: 'learningpool', component: LearningPath },
  { path: '/learningpool/category/:category', name: 'learningpool-category', component: LearningPoolCategory },
  { path: '/my-paths', name: 'my-paths', component: LearningPathsList },
  { path: '/createpath', name: 'createpath', component: CreatePath },
  // Legacy routes (redirects)
  { path: '/learningpath-detail', redirect: { name: 'learningpool' } },
  { path: '/learningpath-pool', redirect: { name: 'learningpool' } },
  // { path: '/my-learning-path', redirect: { name: 'mypaths' } },

  { path: '/login', name: 'login', component: Login },
  { path: '/register', name: 'register', component: Register },
  { path: '/resources', name: 'resources', component: ResourceLibrary },
  { path: '/my-resources', name: 'my-resources', component: MyResource },
  { path: '/resources/video/:id', name: 'resource-video', component: ResourceVideo },
  { path: '/resources/document/:id', name: 'resource-document', component: ResourceDocument },
  { path: '/resources/:type/:id/add-to-path', name: 'resource-add-to-path', component: AddResourceToPath },


  { path: '/learningpath/:id/edit', name: 'learningpath-edit', component: LearningPathEdit },
  { path: '/learningpath/:id/detail', name: 'learningpath-detail', component: LearningPathDetail },
  { path: '/learningpath/:id/linear', name: 'learningpath-linear', component: LearningPathLinear },
  { path: '/learningpath/:id', name: 'learningpath', component: LearningPathDetail },

  { path: '/partical', name: 'partical', component: Partical },
  { path: '/plan', name: 'plan', component: Plan },
  { path: '/about', name: 'about', component: About },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
