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
const ResourceArticle = () => import('./pages/ResourceArticle.vue')
const AddResourceToPath = () => import('./pages/AddResourceToPath.vue')
const MyResource = () => import('./pages/MyResource.vue')
const AddResource = () => import('./pages/AddResource.vue')
const MyResourceEdit = () => import('./pages/MyResourceEdit.vue')
const Partical = () => import('./pages/Partical.vue')
const ParticalImage = () => import('./pages/ParticalImage.vue')
const ParticalFlashedIdeas = () => import('./pages/ParticalFlashedIdeas.vue')
const MyPartical = () => import('./pages/MyPartical.vue')
const MyParticalHome = () => import('./pages/MyParticalHome.vue')
const LearningPathDetail = () => import('./pages/LearningPathDetail.vue')
const LearningPathLinear = () => import('./pages/LearningPathLinear.vue')
const LearningPoolCategory = () => import('./pages/LearningPoolCategory.vue')
const CreatePath = () => import('./pages/CreatePath.vue')
const LearningPathEdit = () => import('./pages/LearningPathEdit.vue')
const Notification = () => import('./pages/Notification.vue')
const Creator = () => import('./pages/Creator.vue')

const Account = () => import('./pages/Account.vue')
const AccountMyResources = () => import('./pages/AccountMyResources.vue')
const AccountMyPaths = () => import('./pages/AccountMyPaths.vue')
const AccountUserInfo = () => import('./pages/AccountUserInfo.vue')
const AccountChangePassword = () => import('./pages/AccountChangePassword.vue')
const AccountPlan = () => import('./pages/AccountPlan.vue')

const About = () => import('./pages/About.vue')
const Plan = () => import('./pages/Plan.vue')
const Tool = () => import('./pages/Tool.vue')

const routes: RouteRecordRaw[] = [
  // Canonical routes
  { path: '/', redirect: { name: 'home' } },
  { path: '/home', name: 'home', component: Home },
  { path: '/notification', name: 'notification', component: Notification },
  { path: '/creator', name: 'creator', component: Creator },
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
  { path: '/my-resources/add', name: 'add-resource', component: AddResource },
  // My resources (typed)
  { path: '/my-resources/video/:id', name: 'my-resource-video', component: ResourceVideo },
  { path: '/my-resources/document/:id', name: 'my-resource-document', component: ResourceDocument },
  { path: '/my-resources/article/:id', name: 'my-resource-article', component: ResourceArticle },
  // Legacy my resource detail route (assume video)
  { path: '/my-resources/:id', redirect: (to) => ({ name: 'my-resource-video', params: { id: String(to.params.id || '') } }) },
  { path: '/my-resources/:id/edit', name: 'my-resource-edit', component: MyResourceEdit },
  { path: '/resources/video/:id', name: 'resource-video', component: ResourceVideo },
  { path: '/resources/document/:id', name: 'resource-document', component: ResourceDocument },
  { path: '/resources/article/:id', name: 'resource-article', component: ResourceArticle },
  { path: '/resources/:type/:id/add-to-path', name: 'resource-add-to-path', component: AddResourceToPath },

  {
    path: '/account',
    component: Account,
    children: [
      { path: '', redirect: { name: 'account-user-info' } },
      { path: 'my-resources', name: 'account-my-resources', component: AccountMyResources },
      { path: 'my-paths', name: 'account-my-paths', component: AccountMyPaths },
      { path: 'user-info', name: 'account-user-info', component: AccountUserInfo },
      { path: 'plan', name: 'account-plan', component: AccountPlan },
      { path: 'change-password', name: 'account-change-password', component: AccountChangePassword },
    ],
  },


  { path: '/learningpath/:id/edit', name: 'learningpath-edit', component: LearningPathEdit },
  { path: '/learningpath/:id/detail', name: 'learningpath-detail', component: LearningPathDetail },
  { path: '/learningpath/:id/linear', name: 'learningpath-linear', component: LearningPathLinear },
  { path: '/learningpath/:id', name: 'learningpath', component: LearningPathDetail },

  {
    path: '/partical',
    component: Partical,
    children: [
      { path: '', redirect: { name: 'partical-image' } },
      { path: 'image', name: 'partical-image', component: ParticalImage },
      { path: 'flashed-ideas', name: 'partical-flashed-ideas', component: ParticalFlashedIdeas },
    ],
  },

  {
    path: '/my-partical',
    component: MyPartical,
    children: [
      { path: '', redirect: { name: 'my-partical-home' } },
      { path: 'home', name: 'my-partical-home', component: MyParticalHome },
      { path: 'image', name: 'my-partical-image', component: ParticalImage },
      { path: 'flashed-ideas', name: 'my-partical-flashed-ideas', component: ParticalFlashedIdeas },
    ],
  },
  { path: '/plan', name: 'plan', component: Plan },
  { path: '/tools', name: 'tools', component: Tool },
  { path: '/about', name: 'about', component: About },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
