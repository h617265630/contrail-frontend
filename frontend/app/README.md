# Vue App Migration

本目录为将现有 React 组件迁移到 Vue 3 + Vite 的最小示例与脚手架。当前已迁移页面：`src/pages/LearningPath.vue`。

## 运行

在 `vue-app` 目录执行：

```bash
npm install
npm run dev
```

然后访问终端输出的本地地址（默认 `http://localhost:5173`）。

## 说明
- 使用 Vue 3 Composition API（`<script setup lang="ts">`）。
- 图标库改用 `lucide-vue-next` 以替代 `lucide-react`。
- 保留了原有的 Tailwind CSS 类名。如未在项目中集成 Tailwind，请另行配置（或将类名替换为常规CSS）。
- 为避免 Set 的响应式问题，对展开项 `expandedItems` 采用替换新引用策略。

## 下一步
- 迁移 `Login.tsx`, `Register.tsx`, `ResourceLibrary.tsx`。
- 针对 `components/ui/*.tsx` 建立 Vue 等价组件或封装（可用 `vue` + `radix-vue` 或自建）。
- 若需要路由，可引入 `vue-router` 并将已迁移页面注册为路由。
