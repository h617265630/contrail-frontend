export type ResourceType = 'video' | 'document' | 'article'

export type Resource = {
  id: string
  title: string
  description: string
  url: string
  type: ResourceType
  category: string
  thumbnail: string
  duration?: string
  pages?: number
  addedDate: string
  source: string
}

export const resourceSeed: Resource[] = [
  {
    id: '1',
    title: 'Advanced React Patterns',
    description: 'Learn advanced React patterns including render props, HOCs, and compound components.',
    url: 'https://example.com/react-patterns',
    type: 'video',
    category: 'Frontend',
    thumbnail: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400&h=225&fit=crop',
    duration: '45min',
    addedDate: '2024-12-20',
    source: 'YouTube',
  },
  {
    id: '2',
    title: 'Node.js Best Practices',
    description: 'Comprehensive guide to writing production-ready Node.js applications.',
    url: 'https://example.com/nodejs-best-practices',
    type: 'document',
    category: 'Backend',
    thumbnail: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=225&fit=crop',
    pages: 85,
    addedDate: '2024-12-19',
    source: '小红书',
  },
  {
    id: '3',
    title: 'Database Design Principles',
    description: 'Essential principles for designing scalable and efficient databases.',
    url: 'https://example.com/db-design',
    type: 'article',
    category: 'Database',
    thumbnail: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=400&h=225&fit=crop',
    pages: 12,
    addedDate: '2024-12-18',
    source: 'Medium',
  },
  {
    id: '4',
    title: 'TypeScript Deep Dive',
    description: 'Master TypeScript with practical examples and advanced type system concepts.',
    url: 'https://example.com/typescript-deep-dive',
    type: 'video',
    category: 'Frontend',
    thumbnail: 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=400&h=225&fit=crop',
    duration: '2h 15min',
    addedDate: '2024-12-17',
    source: 'YouTube',
  },
  {
    id: '5',
    title: 'Docker & Kubernetes Guide',
    description: 'Complete guide to containerization and orchestration with Docker and K8s.',
    url: 'https://example.com/docker-k8s',
    type: 'document',
    category: 'DevOps',
    thumbnail: 'https://images.unsplash.com/photo-1605745341112-85968b19335b?w=400&h=225&fit=crop',
    pages: 120,
    addedDate: '2024-12-16',
    source: 'X',
  },
  {
    id: '6',
    title: 'UI/UX Design Fundamentals',
    description: 'Learn the principles of user interface and user experience design from scratch.',
    url: 'https://example.com/ui-ux-fundamentals',
    type: 'video',
    category: 'Design',
    thumbnail: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400&h=225&fit=crop',
    duration: '1h 30min',
    addedDate: '2024-12-15',
    source: 'Bilibili',
  },
  {
    id: '7',
    title: 'RESTful API Design',
    description: 'Best practices for designing scalable and maintainable RESTful APIs.',
    url: 'https://example.com/restful-api',
    type: 'article',
    category: 'Backend',
    thumbnail: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&h=225&fit=crop',
    pages: 18,
    addedDate: '2024-12-14',
    source: 'Dev.to',
  },
  {
    id: '8',
    title: 'MongoDB Complete Course',
    description: 'From basics to advanced queries, aggregation, and performance optimization.',
    url: 'https://example.com/mongodb-course',
    type: 'video',
    category: 'Database',
    thumbnail: 'https://images.unsplash.com/photo-1551033406-611cf9a28f67?w=400&h=225&fit=crop',
    duration: '3h 45min',
    addedDate: '2024-12-13',
    source: 'YouTube',
  },
  {
    id: '9',
    title: 'CI/CD Pipeline Setup',
    description: 'Step-by-step guide to setting up continuous integration and deployment pipelines.',
    url: 'https://example.com/cicd-pipeline',
    type: 'document',
    category: 'DevOps',
    thumbnail: 'https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=400&h=225&fit=crop',
    pages: 45,
    addedDate: '2024-12-12',
    source: '小红书',
  },
  {
    id: '10',
    title: 'Figma for Developers',
    description: 'How developers can leverage Figma for better design-to-code workflow.',
    url: 'https://example.com/figma-developers',
    type: 'article',
    category: 'Design',
    thumbnail: 'https://images.unsplash.com/photo-1609921212029-bb5a28e60960?w=400&h=225&fit=crop',
    pages: 10,
    addedDate: '2024-12-11',
    source: 'Medium',
  },
]
