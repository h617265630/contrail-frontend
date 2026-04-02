import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useAuthStore } from './stores/auth'

// Route-level SEO meta interface
interface SeoMeta {
  title: string
  description: string
  noindex?: boolean
  type?: 'website' | 'article' | 'profile'
}

declare module 'vue-router' {
  interface RouteMeta {
    seo?: SeoMeta
    requiresAdmin?: boolean
  }
}

// Lazy-loaded routes to avoid ReferenceError during HMR/initial load
const Home = () => import('./pages/Home.vue')
const LearningPathsList = () => import('./pages/MyLearningPath.vue')
const LearningPool = () => import('./pages/LearningPool.vue')
const LearningPathDetail = () => import('./pages/LearningPathDetail.vue')
const LearningPathLinear = () => import('./pages/LearningPathLinear.vue')
const LearningPathEdit = () => import('./pages/LearningPathEdit.vue')
const Login = () => import('./pages/Login.vue')
const Register = () => import('./pages/Register.vue')
const ResourceLibrary = () => import('./pages/ResourceLibrary.vue')
const ResourcesTrend = () => import('./pages/ResourcesTrend.vue')
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
const LearningPoolCategory = () => import('./pages/LearningPoolCategory.vue')
const CreatePath = () => import('./pages/CreatePath.vue')
const Notification = () => import('./pages/Notification.vue')
const Creator = () => import('./pages/Creator.vue')
const Deck = () => import('./pages/Deck.vue')
const AIPath = () => import('./pages/AIPath.vue')
const AIPathDetail = () => import('./pages/AIPathDetail.vue')

const UiUxProMax = () => import('./pages/UiUxProMax.vue')

const Account = () => import('./pages/Account.vue')
const AccountMyResources = () => import('./pages/AccountMyResources.vue')
const AccountMyPaths = () => import('./pages/AccountMyPaths.vue')
const AccountUserInfo = () => import('./pages/AccountUserInfo.vue')
const AccountChangePassword = () => import('./pages/AccountChangePassword.vue')
const AccountPlan = () => import('./pages/AccountPlan.vue')

const About = () => import('./pages/About.vue')
const AboutResources = () => import('./pages/AboutResources.vue')
const AboutLearningPaths = () => import('./pages/AboutLearningPaths.vue')
const AboutProgress = () => import('./pages/AboutProgress.vue')
const Plan = () => import('./pages/Plan.vue')
const Tool = () => import('./pages/Tool.vue')
const Stack = () => import('./pages/stackUI/Stack.vue')
const CardUI = () => import('./pages/CardUI.vue')

// Admin pages
const AdminLayout = () => import('./pages/admin/AdminLayout.vue')
const AdminDashboard = () => import('./pages/admin/Dashboard.vue')
const AdminUserManagement = () => import('./pages/admin/UserManagement.vue')
const AdminResourceManagement = () => import('./pages/admin/ResourceManagement.vue')
const AdminLearningPathManagement = () => import('./pages/admin/LearningPathManagement.vue')
const AdminAnalytics = () => import('./pages/admin/Analytics.vue')

const routes: RouteRecordRaw[] = [
  // Canonical routes
  { path: '/', redirect: { name: 'home' } },
  {
    path: '/home',
    name: 'home',
    component: Home,
    meta: {
      seo: {
        title: 'Learnpathly - Discover, Learn, Grow',
        description: 'Discover learning resources, build learning paths, and generate AI-guided study plans. Your personal learning companion.',
      },
    },
  },
  {
    path: '/notification',
    name: 'notification',
    component: Notification,
    meta: { seo: { title: 'Notifications - Learnpathly', description: 'Your learning notifications and updates.', noindex: true } },
  },
  {
    path: '/creator',
    name: 'creator',
    component: Creator,
    meta: {
      seo: {
        title: 'Content Creator - Learnpathly',
        description: 'Create and share learning content on Learnpathly.',
      },
    },
  },
  {
    path: '/deck',
    name: 'deck',
    component: Deck,
    meta: {
      seo: {
        title: 'Deck - Learnpathly',
        description: 'Browse your flashcard decks for active recall learning.',
      },
    },
  },
  {
    path: '/ai-path',
    name: 'ai-path',
    component: AIPath,
    meta: {
      seo: {
        title: 'AI Path Generator - Learnpathly',
        description: 'Describe what you want to learn and get an AI-generated learning path with structured stages and curated resources.',
      },
    },
  },
  {
    path: '/ai-path-detail',
    name: 'ai-path-detail',
    component: AIPathDetail,
    meta: { seo: { title: 'AI Path Detail - Learnpathly', description: 'Your personalized AI-generated learning path.', noindex: true } },
  },
  {
    path: '/learningpool',
    name: 'learningpool',
    component: LearningPool,
    meta: {
      seo: {
        title: 'Learning Pool - Learnpathly',
        description: 'Explore public learning paths shared by the community. Find structured learning resources on any topic.',
      },
    },
  },
  {
    path: '/learningpool/category/:category',
    name: 'learningpool-category',
    component: LearningPoolCategory,
    meta: {
      seo: {
        title: 'Learning Pool - Learnpathly',
        description: 'Browse learning paths by category.',
      },
    },
  },
  {
    path: '/my-paths',
    name: 'my-paths',
    component: LearningPathsList,
    meta: { seo: { title: 'My Learning Paths - Learnpathly', description: 'Your personal learning paths.', noindex: true } },
  },
  {
    path: '/createpath',
    name: 'createpath',
    component: CreatePath,
    meta: { seo: { title: 'Create Learning Path - Learnpathly', description: 'Create a new learning path to organize your studies.', noindex: true } },
  },
  // Legacy routes (redirects)
  { path: '/learningpath-detail', redirect: { name: 'learningpool' } },
  { path: '/learningpath-pool', redirect: { name: 'learningpool' } },

  {
    path: '/login',
    name: 'login',
    component: Login,
    meta: { seo: { title: 'Sign In - Learnpathly', description: 'Sign in to your Learnpathly account.', noindex: true } },
  },
  {
    path: '/register',
    name: 'register',
    component: Register,
    meta: { seo: { title: 'Create Account - Learnpathly', description: 'Create your free Learnpathly account and start learning.', noindex: true } },
  },
  {
    path: '/resources',
    name: 'resources',
    component: ResourceLibrary,
    meta: {
      seo: {
        title: 'Resource Library - Learnpathly',
        description: 'Browse curated learning resources including videos, documents, and articles. Find quality materials for any topic.',
      },
    },
  },
  {
    path: '/resources-trend',
    name: 'resources-trend',
    component: ResourcesTrend,
    meta: {
      seo: {
        title: 'Trending Resources - Learnpathly',
        description: 'Discover the most popular and trending learning resources on Learnpathly.',
      },
    },
  },
  {
    path: '/my-resources',
    name: 'my-resources',
    component: MyResource,
    meta: { seo: { title: 'My Resources - Learnpathly', description: 'Your saved and uploaded learning resources.', noindex: true } },
  },
  {
    path: '/my-resources/add',
    name: 'add-resource',
    component: AddResource,
    meta: { seo: { title: 'Add Resource - Learnpathly', description: 'Add a new learning resource to your collection.', noindex: true } },
  },
  {
    path: '/my-resources/video/:id',
    name: 'my-resource-video',
    component: ResourceVideo,
    meta: { seo: { title: 'My Video Resource - Learnpathly', description: 'Your saved video resource.', noindex: true } },
  },
  {
    path: '/my-resources/document/:id',
    name: 'my-resource-document',
    component: ResourceDocument,
    meta: { seo: { title: 'My Document Resource - Learnpathly', description: 'Your saved document resource.', noindex: true } },
  },
  {
    path: '/my-resources/article/:id',
    name: 'my-resource-article',
    component: ResourceArticle,
    meta: { seo: { title: 'My Article Resource - Learnpathly', description: 'Your saved article resource.', noindex: true } },
  },
  {
    path: '/my-resources/:id',
    redirect: (to) => ({ name: 'my-resource-video', params: { id: String(to.params.id || '') } }),
  },
  {
    path: '/my-resources/:id/edit',
    name: 'my-resource-edit',
    component: MyResourceEdit,
    meta: { seo: { title: 'Edit Resource - Learnpathly', description: 'Edit your learning resource.', noindex: true } },
  },
  {
    path: '/resources/video/:id',
    name: 'resource-video',
    component: ResourceVideo,
    meta: { seo: { title: 'Video Resource - Learnpathly', description: 'Watch and learn from this video resource.' } },
  },
  {
    path: '/resources/document/:id',
    name: 'resource-document',
    component: ResourceDocument,
    meta: { seo: { title: 'Document Resource - Learnpathly', description: 'Read and learn from this document resource.' } },
  },
  {
    path: '/resources/article/:id',
    name: 'resource-article',
    component: ResourceArticle,
    meta: { seo: { title: 'Article Resource - Learnpathly', description: 'Read and learn from this article resource.' } },
  },
  {
    path: '/resources/:type/:id/add-to-path',
    name: 'resource-add-to-path',
    component: AddResourceToPath,
    meta: { seo: { title: 'Add to Learning Path - Learnpathly', description: 'Add this resource to one of your learning paths.', noindex: true } },
  },

  {
    path: '/account',
    component: Account,
    meta: { seo: { title: 'Account - Learnpathly', description: 'Manage your account settings.', noindex: true } },
    children: [
      { path: '', redirect: { name: 'account-user-info' } },
      {
        path: 'my-resources',
        name: 'account-my-resources',
        component: AccountMyResources,
        meta: { seo: { title: 'My Resources - Learnpathly', description: 'Your saved resources.', noindex: true } },
      },
      {
        path: 'my-paths',
        name: 'account-my-paths',
        component: AccountMyPaths,
        meta: { seo: { title: 'My Learning Paths - Learnpathly', description: 'Your created paths.', noindex: true } },
      },
      {
        path: 'user-info',
        name: 'account-user-info',
        component: AccountUserInfo,
        meta: { seo: { title: 'Profile - Learnpathly', description: 'Your profile information.', noindex: true } },
      },
      {
        path: 'plan',
        name: 'account-plan',
        component: AccountPlan,
        meta: { seo: { title: 'My Plan - Learnpathly', description: 'Your subscription plan.', noindex: true } },
      },
      {
        path: 'change-password',
        name: 'account-change-password',
        component: AccountChangePassword,
        meta: { seo: { title: 'Change Password - Learnpathly', description: 'Update your password.', noindex: true } },
      },
    ],
  },

  {
    path: '/learningpath/:id/edit',
    name: 'learningpath-edit',
    component: LearningPathEdit,
    meta: { seo: { title: 'Edit Learning Path - Learnpathly', description: 'Edit your learning path.', noindex: true } },
  },
  {
    path: '/learningpath/:id/detail',
    name: 'learningpath-detail',
    component: LearningPathDetail,
    meta: { seo: { title: 'Learning Path - Learnpathly', description: 'View this learning path.', type: 'article' } },
  },
  {
    path: '/learningpath/:id/linear',
    name: 'learningpath-linear',
    component: LearningPathLinear,
    meta: { seo: { title: 'Learning Path (Linear View) - Learnpathly', description: 'View this learning path in linear format.', noindex: true } },
  },
  {
    path: '/learningpath/:id',
    name: 'learningpath',
    component: LearningPathDetail,
    meta: { seo: { title: 'Learning Path - Learnpathly', description: 'View this learning path.', type: 'article' } },
  },

  {
    path: '/partical',
    component: Partical,
    meta: { seo: { title: 'Partical - Learnpathly', description: 'Create flashcards from your learning materials.', noindex: true } },
    children: [
      { path: '', redirect: { name: 'partical-image' } },
      {
        path: 'image',
        name: 'partical-image',
        component: ParticalImage,
        meta: { seo: { title: 'Image Flashcards - Learnpathly', description: 'Create flashcards from images.', noindex: true } },
      },
      {
        path: 'flashed-ideas',
        name: 'partical-flashed-ideas',
        component: ParticalFlashedIdeas,
        meta: { seo: { title: 'Flashed Ideas - Learnpathly', description: 'Quick flashcards for active recall.', noindex: true } },
      },
    ],
  },

  {
    path: '/my-partical',
    component: MyPartical,
    meta: { seo: { title: 'My Flashcards - Learnpathly', description: 'Your flashcard decks for active recall learning.', noindex: true } },
    children: [
      { path: '', redirect: { name: 'my-partical-home' } },
      {
        path: 'home',
        name: 'my-partical-home',
        component: MyParticalHome,
        meta: { seo: { title: 'My Flashcards - Learnpathly', description: 'Your flashcard decks.', noindex: true } },
      },
      {
        path: 'image',
        name: 'my-partical-image',
        component: ParticalImage,
        meta: { seo: { title: 'My Image Flashcards - Learnpathly', description: 'Your image-based flashcards.', noindex: true } },
      },
      {
        path: 'flashed-ideas',
        name: 'my-partical-flashed-ideas',
        component: ParticalFlashedIdeas,
        meta: { seo: { title: 'My Flashed Ideas - Learnpathly', description: 'Your quick recall flashcards.', noindex: true } },
      },
    ],
  },
  {
    path: '/plan',
    name: 'plan',
    component: Plan,
    meta: {
      seo: {
        title: 'Pricing Plans - Learnpathly',
        description: 'Choose the plan that fits your learning journey. Free and Pro options available.',
      },
    },
  },
  {
    path: '/tools',
    name: 'tools',
    component: Tool,
    meta: {
      seo: {
        title: 'Learning Tools - Learnpathly',
        description: 'Tools to enhance your learning: flashcards, spaced repetition, and more.',
      },
    },
  },
  {
    path: '/stack',
    name: 'stack',
    component: Stack,
    meta: { seo: { title: 'UI Components - Learnpathly', description: 'UI component showcase.', noindex: true } },
  },
  {
    path: '/card-ui',
    name: 'card-ui',
    component: CardUI,
    meta: { seo: { title: 'Card UI - Learnpathly', description: 'Card component showcase.', noindex: true } },
  },
  {
    path: '/about',
    name: 'about',
    component: About,
    meta: {
      seo: {
        title: 'About Learnpathly',
        description: 'Learn how Learnpathly helps you organize resources, build learning paths, and track your progress.',
      },
    },
  },
  {
    path: '/about/resources',
    name: 'about-resources',
    component: AboutResources,
    meta: {
      seo: {
        title: 'About Resources - Learnpathly',
        description: 'How Learnpathly helps you discover and organize learning resources.',
      },
    },
  },
  {
    path: '/about/learning-paths',
    name: 'about-learning-paths',
    component: AboutLearningPaths,
    meta: {
      seo: {
        title: 'About Learning Paths - Learnpathly',
        description: 'How structured learning paths help you achieve your goals.',
      },
    },
  },
  {
    path: '/about/progress',
    name: 'about-progress',
    component: AboutProgress,
    meta: {
      seo: {
        title: 'About Progress Tracking - Learnpathly',
        description: 'Track your learning progress and stay motivated.',
      },
    },
  },

  // Admin routes
  {
    path: '/admin',
    component: AdminLayout,
    meta: { requiresAdmin: true, seo: { title: 'Admin - Learnpathly', description: 'Admin dashboard.', noindex: true } },
    children: [
      { path: '', redirect: { name: 'admin-dashboard' } },
      {
        path: 'dashboard',
        name: 'admin-dashboard',
        component: AdminDashboard,
        meta: { seo: { title: 'Dashboard - Admin - Learnpathly', description: 'Admin dashboard overview.', noindex: true } },
      },
      {
        path: 'users',
        name: 'admin-users',
        component: AdminUserManagement,
        meta: { seo: { title: 'User Management - Admin - Learnpathly', description: 'Manage platform users.', noindex: true } },
      },
      {
        path: 'resources',
        name: 'admin-resources',
        component: AdminResourceManagement,
        meta: { seo: { title: 'Resource Management - Admin - Learnpathly', description: 'Manage platform resources.', noindex: true } },
      },
      {
        path: 'paths',
        name: 'admin-paths',
        component: AdminLearningPathManagement,
        meta: { seo: { title: 'Path Management - Admin - Learnpathly', description: 'Manage learning paths.', noindex: true } },
      },
      {
        path: 'analytics',
        name: 'admin-analytics',
        component: AdminAnalytics,
        meta: { seo: { title: 'Analytics - Admin - Learnpathly', description: 'Platform analytics and insights.', noindex: true } },
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// Admin route guard
router.beforeEach(async (to, _from, next) => {
  if (to.meta?.requiresAdmin) {
    const authStore = useAuthStore()
    // Ensure auth state is loaded
    if (authStore.isAuthed && !authStore.user) {
      try {
        await authStore.fetchProfile()
      } catch {
        authStore.logout()
        next({ name: 'login' })
        return
      }
    }
    const user = authStore.user as any
    if (!user?.is_superuser) {
      // Redirect non-admins to home
      next({ name: 'home' })
      return
    }
  }
  next()
})

export default router
