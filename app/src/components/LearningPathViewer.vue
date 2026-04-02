<template>
  <div class="learning-path-viewer">
    <!-- 头部 -->
    <header class="path-header">
      <h1>{{ data.topic }} 学习路径</h1>
      <div class="meta">
        <span v-if="data.difficulty">难度: {{ data.difficulty }}</span>
        <span v-if="data.estimated_duration"> | 预计时长: {{ data.estimated_duration }}</span>
      </div>
    </header>

    <!-- 学习全景图 -->
    <section v-if="data.panorama_title" class="section panorama">
      <h2>{{ data.panorama_title }}</h2>
      <p class="intro">{{ data.panorama_intro }}</p>
    </section>

    <!-- 节点列表 -->
    <section v-if="data.big_nodes?.length" class="section path-section">
      <h2>{{ data.path_title }}</h2>
      
      <div class="node-list">
        <div 
          v-for="(node, index) in data.big_nodes" 
          :key="index" 
          class="node-card"
        >
          <!-- 节点标题 -->
          <div class="node-header">
            <span class="node-index">{{ node.index }}</span>
            <h3>{{ node.name }}</h3>
          </div>
          
          <!-- 节点介绍 -->
          <p class="node-intro">{{ node.intro }}</p>
          
          <!-- 子知识点 -->
          <div v-if="node.sub_knowledge?.length" class="sub-knowledge">
            <h4>子知识点</h4>
            <ul>
              <li v-for="(sub, i) in node.sub_knowledge" :key="i">
                <strong>{{ sub.name }}</strong>: {{ sub.intro }}
              </li>
            </ul>
          </div>
          
          <!-- 推荐资源 -->
          <div v-if="node.resources?.length" class="resources">
            <h4>推荐资源</h4>
            <div class="resource-list">
              <a 
                v-for="(resource, i) in node.resources" 
                :key="i"
                :href="resource.url"
                target="_blank"
                class="resource-card"
              >
                <div class="resource-icon">🔗</div>
                <div class="resource-info">
                  <div class="resource-title">{{ resource.title }}</div>
                  <div class="resource-url">{{ formatUrl(resource.url) }}</div>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Markdown 渲染（备用） -->
    <section v-if="data.display_markdown" class="section markdown-section">
      <h2>完整内容</h2>
      <div class="markdown-body" v-html="renderMarkdown(data.display_markdown)"></div>
    </section>
  </div>
</template>

<script setup>
import { marked } from 'marked'

const props = defineProps({
  data: {
    type: Object,
    required: true,
    default: () => ({})
  }
})

// 格式化 URL 显示
function formatUrl(url) {
  try {
    return new URL(url).hostname
  } catch {
    return url
  }
}

// 渲染 Markdown
function renderMarkdown(text) {
  if (!text) return ''
  return marked(text)
}
</script>

<style scoped>
.learning-path-viewer {
  max-width: 800px;
  margin: 0 auto;
  padding: 24px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.path-header {
  margin-bottom: 32px;
  padding-bottom: 16px;
  border-bottom: 1px solid #eee;
}

.path-header h1 {
  font-size: 28px;
  margin: 0 0 8px;
  color: #1a1a1a;
}

.meta {
  color: #666;
  font-size: 14px;
}

.section {
  margin-bottom: 32px;
}

.section h2 {
  font-size: 20px;
  margin: 0 0 16px;
  color: #333;
}

.intro {
  color: #666;
  line-height: 1.6;
}

/* 节点卡片 */
.node-card {
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 16px;
  transition: box-shadow 0.2s;
}

.node-card:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.node-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.node-index {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  background: #0070f3;
  color: #fff;
  border-radius: 50%;
  font-size: 14px;
  font-weight: 600;
  flex-shrink: 0;
}

.node-header h3 {
  margin: 0;
  font-size: 18px;
  color: #1a1a1a;
}

.node-intro {
  color: #666;
  line-height: 1.6;
  margin: 0 0 16px;
}

/* 子知识点 */
.sub-knowledge {
  margin-bottom: 16px;
}

.sub-knowledge h4 {
  font-size: 14px;
  color: #666;
  margin: 0 0 8px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.sub-knowledge ul {
  margin: 0;
  padding-left: 20px;
}

.sub-knowledge li {
  margin-bottom: 8px;
  line-height: 1.5;
}

.sub-knowledge strong {
  color: #333;
}

/* 资源卡片 */
.resources h4 {
  font-size: 14px;
  color: #666;
  margin: 0 0 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.resource-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.resource-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #f8f9fa;
  border-radius: 8px;
  text-decoration: none;
  color: inherit;
  transition: background 0.2s;
}

.resource-card:hover {
  background: #f1f3f5;
}

.resource-icon {
  font-size: 20px;
}

.resource-title {
  font-weight: 500;
  color: #1a1a1a;
}

.resource-url {
  font-size: 12px;
  color: #999;
  margin-top: 2px;
}

/* Markdown 区域 */
.markdown-body {
  line-height: 1.7;
  color: #333;
}

.markdown-body :deep(h1) { font-size: 24px; margin: 24px 0 12px; }
.markdown-body :deep(h2) { font-size: 20px; margin: 20px 0 10px; }
.markdown-body :deep(h3) { font-size: 16px; margin: 16px 0 8px; }
.markdown-body :deep(p) { margin: 8px 0; }
.markdown-body :deep(ul), .markdown-body :deep(ol) { padding-left: 24px; }
.markdown-body :deep(li) { margin: 4px 0; }
.markdown-body :deep(a) { color: #0070f3; }
.markdown-body :deep(code) {
  background: #f5f5f5;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 0.9em;
}
</style>
