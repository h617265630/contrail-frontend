<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto space-y-10">

      <!-- Hero -->
      <section class="rounded-2xl bg-white shadow-lg p-8 md:p-12 flex flex-col gap-6">
        <div class="space-y-3 max-w-3xl">
          <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">About</p>
          <h1 class="text-3xl md:text-4xl font-bold text-gray-900 leading-tight">Learning Path Platform 简介</h1>
          <p class="text-gray-700 text-base leading-relaxed">
            这是一个基于 Vue + Tailwind 的学习路径展示与资源管理前端。涵盖首页、Learning Path 列表、路径详情、资源库、登录注册等页面，支持横向滚动查看路径节点、卡片化展示笔记与进度，并提供统一的导航栏与页脚。
          </p>
        </div>
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          <div class="rounded-xl bg-blue-50/50 shadow-sm p-4">
            <h3 class="font-semibold text-gray-900">技术栈</h3>
            <p class="text-sm text-gray-700 mt-1">Vue 3 + Vite + TypeScript，样式使用 TailwindCSS，图标使用 lucide-vue-next。</p>
          </div>
          <div class="rounded-xl bg-purple-50/40 shadow-sm p-4">
            <h3 class="font-semibold text-gray-900">页面与路由</h3>
            <p class="text-sm text-gray-700 mt-1">Home（首页 Banner + 精选路径）、Learning Paths 列表（横向滚动节点卡片）、LearningPath 详情、Resources 资源库、Login/Register、About、Footer/NavBar 统一布局。</p>
          </div>
          <div class="rounded-xl bg-green-50/40 shadow-sm p-4">
            <h3 class="font-semibold text-gray-900">学习路径展示</h3>
            <p class="text-sm text-gray-700 mt-1">单行 5 卡片精选展示；列表页支持多条路径，每条路径下的节点可横向滚动，长文本自动省略。</p>
          </div>
        </div>
      </section>

      <!-- Sections -->
      <section class="grid gap-6 md:grid-cols-2">
        <div class="rounded-2xl bg-white shadow-lg p-6 space-y-3">
          <h2 class="text-xl font-semibold text-gray-900">核心功能</h2>
          <ul class="space-y-2 text-gray-700 text-sm leading-relaxed list-disc list-inside">
            <li>学习路径列表：横向滚动的节点卡片，支持快速浏览。</li>
            <li>路径详情页：时间轴 + 进度条 + 笔记编辑交互。</li>
            <li>资源库：网格/列表双模式、筛选搜索、增删改资源模态框。</li>
            <li>登录/注册：表单校验与密码显隐切换。</li>
            <li>统一导航与页脚：全局路由入口、登录注册入口、资源与路径入口。</li>
          </ul>
        </div>
        <div class="rounded-2xl bg-white shadow-lg p-6 space-y-3">
          <h2 class="text-xl font-semibold text-gray-900">体验亮点</h2>
          <ul class="space-y-2 text-gray-700 text-sm leading-relaxed list-disc list-inside">
            <li>卡片化与渐变 Banner，突出重点路径。</li>
            <li>line-clamp 处理长文案，保持整洁排版。</li>
            <li>Tailwind 公用布局：max-w-7xl 居中、柔和阴影和圆角。</li>
            <li>可扩展：可接入真实后端 API，替换 mock 数据。</li>
          </ul>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>
