import { ref } from 'vue'

export type AppLang = 'en' | 'zh-CN'

const STORAGE_KEY = 'learnpathly_lang'

function readInitialLang(): AppLang {
  try {
    const stored = (globalThis as any)?.localStorage?.getItem(STORAGE_KEY)
    if (stored === 'en' || stored === 'zh-CN') return stored
  } catch {
    // ignore
  }
  return 'en'
}

export const currentLang = ref<AppLang>(readInitialLang())

function syncDocumentLang(lang: AppLang) {
  try {
    const doc = (globalThis as any)?.document
    if (doc?.documentElement) {
      doc.documentElement.lang = lang === 'en' ? 'en' : 'zh-CN'
    }
  } catch {
    // ignore
  }
}

syncDocumentLang(currentLang.value)

export function setLang(lang: AppLang) {
  currentLang.value = lang
  syncDocumentLang(lang)
  try {
    ;(globalThis as any)?.localStorage?.setItem(STORAGE_KEY, lang)
  } catch {
    // ignore
  }
}

// Minimal dictionary: keys are EN strings; zh-CN provides translations.
const zhCN: Record<string, string> = {
  'Search...': '搜索…',
  'User menu': '用户菜单',
  'My Paths': '我的学习路径',
  'My Collection': '我的收藏',
  'Creator Center': '创作中心',
  'Log out': '退出登录',
  'CreatePath': '创建路径',
  'Home': '首页',
  'Resources': '资源库',
  'View all paths': '查看全部路径',
  'Start now': '立即开始',
  'Create path': '创建路径',
  'Uncategorized': '未分类',
  'Learnpathly': 'Learnpathly',
  'Learning Path Platform': '学习路径平台',
  'Build system-level skills with structured learning paths': '用路径化、结构化学习，构建体系化能力',
  'This is a Learning Path Platform: create and discover great learning paths, turn scattered knowledge into an actionable plan, and track progress as you improve over time.':
    '这是一个学习路径平台：自由创建与查阅优秀学习路径，把零散知识串成可执行计划，并追踪进度持续完善。',
  'About': '关于',
}

export function t(text: string): string {
  if (currentLang.value === 'zh-CN') return zhCN[text] ?? text
  return text
}

export function useI18n() {
  return {
    lang: currentLang,
    setLang,
    t,
    languages: [
      { code: 'en' as const, label: 'English' },
      { code: 'zh-CN' as const, label: '中文' },
    ],
  }
}
