import { useState } from 'react';
import { Plus, Search, Grid3x3, List, Edit2, Trash2, Link as LinkIcon, Video, FileText, BookOpen, Tag, Filter, ChevronDown, X, Check, ArrowRight } from 'lucide-react';

interface Resource {
  id: string;
  title: string;
  description: string;
  url: string;
  type: 'video' | 'document' | 'article';
  category: string;
  thumbnail: string;
  duration?: string;
  pages?: number;
  addedDate: string;
  source: string; // '小红书', 'X', 'YouTube', etc.
}

interface LearningPath {
  id: string;
  title: string;
  itemCount: number;
}

export function ResourceLibrary() {
  const [resources, setResources] = useState<Resource[]>([
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
      source: 'YouTube'
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
      source: '小红书'
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
      source: 'Medium'
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
      source: 'YouTube'
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
      source: 'X'
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
      source: 'Bilibili'
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
      source: 'Dev.to'
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
      source: 'YouTube'
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
      source: '小红书'
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
      source: 'Medium'
    }
  ]);

  const [viewMode, setViewMode] = useState<'grid' | 'list'>('grid');
  const [selectedCategory, setSelectedCategory] = useState<string>('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showAddToPathModal, setShowAddToPathModal] = useState(false);
  const [selectedResources, setSelectedResources] = useState<Set<string>>(new Set());
  const [editingResource, setEditingResource] = useState<Resource | null>(null);

  // Mock learning paths
  const [learningPaths] = useState<LearningPath[]>([
    { id: '1', title: 'Full Stack Web Development', itemCount: 5 },
    { id: '2', title: 'Backend Engineering', itemCount: 3 },
    { id: '3', title: 'Frontend Mastery', itemCount: 4 }
  ]);

  // New resource form
  const [newResource, setNewResource] = useState({
    title: '',
    description: '',
    url: '',
    type: 'video' as 'video' | 'document' | 'article',
    category: '',
    source: '',
    duration: '',
    pages: ''
  });

  const categories = ['All', 'Frontend', 'Backend', 'Database', 'DevOps', 'Design', 'Other'];

  const filteredResources = resources.filter(resource => {
    const matchesCategory = selectedCategory === 'All' || resource.category === selectedCategory;
    const matchesSearch = resource.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         resource.description.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  const handleAddResource = () => {
    const resource: Resource = {
      id: Date.now().toString(),
      title: newResource.title,
      description: newResource.description,
      url: newResource.url,
      type: newResource.type,
      category: newResource.category,
      thumbnail: `https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400&h=225&fit=crop&sig=${Date.now()}`,
      duration: newResource.duration,
      pages: newResource.pages ? parseInt(newResource.pages) : undefined,
      addedDate: new Date().toISOString().split('T')[0],
      source: newResource.source
    };

    setResources([...resources, resource]);
    setShowAddModal(false);
    setNewResource({
      title: '',
      description: '',
      url: '',
      type: 'video',
      category: '',
      source: '',
      duration: '',
      pages: ''
    });
  };

  const handleUpdateResource = () => {
    if (!editingResource) return;
    
    setResources(resources.map(r => 
      r.id === editingResource.id ? editingResource : r
    ));
    setShowEditModal(false);
    setEditingResource(null);
  };

  const handleDeleteResource = (id: string) => {
    if (confirm('Are you sure you want to delete this resource?')) {
      setResources(resources.filter(r => r.id !== id));
      setSelectedResources(prev => {
        const newSet = new Set(prev);
        newSet.delete(id);
        return newSet;
      });
    }
  };

  const toggleResourceSelection = (id: string) => {
    const newSelected = new Set(selectedResources);
    if (newSelected.has(id)) {
      newSelected.delete(id);
    } else {
      newSelected.add(id);
    }
    setSelectedResources(newSelected);
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'video':
        return <Video className="w-4 h-4" />;
      case 'document':
        return <FileText className="w-4 h-4" />;
      case 'article':
        return <BookOpen className="w-4 h-4" />;
      default:
        return <FileText className="w-4 h-4" />;
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'video':
        return 'bg-purple-100 text-purple-600';
      case 'document':
        return 'bg-blue-100 text-blue-600';
      case 'article':
        return 'bg-green-100 text-green-600';
      default:
        return 'bg-gray-100 text-gray-600';
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-gray-900 mb-2">Resource Library</h1>
          <p className="text-gray-600">Manage your learning resources and add them to learning paths</p>
        </div>

        {/* Toolbar */}
        <div className="bg-white rounded-xl shadow-lg p-4 mb-6">
          <div className="flex flex-col lg:flex-row gap-4 items-start lg:items-center justify-between">
            {/* Left side - Search and Filter */}
            <div className="flex flex-col sm:flex-row gap-3 flex-1 w-full lg:w-auto">
              {/* Search */}
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  placeholder="Search resources..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              {/* Category Filter */}
              <div className="relative">
                <select
                  value={selectedCategory}
                  onChange={(e) => setSelectedCategory(e.target.value)}
                  className="appearance-none pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white cursor-pointer"
                >
                  {categories.map(cat => (
                    <option key={cat} value={cat}>{cat}</option>
                  ))}
                </select>
                <Filter className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
                <ChevronDown className="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
              </div>
            </div>

            {/* Right side - Actions */}
            <div className="flex gap-3 w-full lg:w-auto">
              {/* View Mode Toggle */}
              <div className="flex gap-1 bg-gray-100 rounded-lg p-1">
                <button
                  onClick={() => setViewMode('grid')}
                  className={`p-2 rounded ${viewMode === 'grid' ? 'bg-white shadow-sm' : 'text-gray-500'}`}
                >
                  <Grid3x3 className="w-5 h-5" />
                </button>
                <button
                  onClick={() => setViewMode('list')}
                  className={`p-2 rounded ${viewMode === 'list' ? 'bg-white shadow-sm' : 'text-gray-500'}`}
                >
                  <List className="w-5 h-5" />
                </button>
              </div>

              {/* Add to Path Button */}
              {selectedResources.size > 0 && (
                <button
                  onClick={() => setShowAddToPathModal(true)}
                  className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors flex items-center gap-2"
                >
                  <Plus className="w-4 h-4" />
                  Add to Path ({selectedResources.size})
                </button>
              )}

              {/* Add Resource Button */}
              <button
                onClick={() => setShowAddModal(true)}
                className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
              >
                <Plus className="w-4 h-4" />
                Add Resource
              </button>
            </div>
          </div>
        </div>

        {/* Resources Display */}
        {viewMode === 'grid' ? (
          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {filteredResources.map(resource => (
              <div
                key={resource.id}
                className={`bg-white rounded-xl shadow-lg overflow-hidden transition-all cursor-pointer ${
                  selectedResources.has(resource.id) ? 'ring-4 ring-blue-500' : 'hover:shadow-xl'
                }`}
              >
                {/* Thumbnail */}
                <div className="relative h-48">
                  <img src={resource.thumbnail} alt={resource.title} className="w-full h-full object-cover" />
                  
                  {/* Selection Checkbox */}
                  <div className="absolute top-3 left-3">
                    <button
                      onClick={() => toggleResourceSelection(resource.id)}
                      className={`w-6 h-6 rounded flex items-center justify-center ${
                        selectedResources.has(resource.id)
                          ? 'bg-blue-600 text-white'
                          : 'bg-white bg-opacity-80 text-gray-600 hover:bg-opacity-100'
                      }`}
                    >
                      {selectedResources.has(resource.id) && <Check className="w-4 h-4" />}
                    </button>
                  </div>

                  {/* Type Badge */}
                  <div className="absolute top-3 right-3">
                    <div className={`px-2 py-1 rounded-full flex items-center gap-1 ${getTypeColor(resource.type)}`}>
                      {getTypeIcon(resource.type)}
                      <span className="text-xs capitalize">{resource.type}</span>
                    </div>
                  </div>

                  {/* Source Badge */}
                  <div className="absolute bottom-3 left-3">
                    <div className="px-2 py-1 rounded-full bg-black bg-opacity-60 text-white text-xs flex items-center gap-1">
                      <LinkIcon className="w-3 h-3" />
                      {resource.source}
                    </div>
                  </div>
                </div>

                {/* Content */}
                <div className="p-4">
                  <div className="flex items-start justify-between mb-2">
                    <h3 className="text-gray-900 flex-1">{resource.title}</h3>
                  </div>
                  
                  <p className="text-gray-600 text-sm mb-3 line-clamp-2">{resource.description}</p>

                  {/* Meta Info */}
                  <div className="flex items-center gap-4 text-xs text-gray-500 mb-3">
                    <div className="flex items-center gap-1">
                      <Tag className="w-3 h-3" />
                      {resource.category}
                    </div>
                    {resource.duration && (
                      <div>{resource.duration}</div>
                    )}
                    {resource.pages && (
                      <div>{resource.pages} pages</div>
                    )}
                  </div>

                  {/* Actions */}
                  <div className="flex gap-2">
                    <button
                      onClick={() => {
                        setEditingResource(resource);
                        setShowEditModal(true);
                      }}
                      className="flex-1 px-3 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors flex items-center justify-center gap-2"
                    >
                      <Edit2 className="w-4 h-4" />
                      Edit
                    </button>
                    <button
                      onClick={() => handleDeleteResource(resource.id)}
                      className="px-3 py-2 bg-red-100 text-red-600 rounded-lg hover:bg-red-200 transition-colors"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="space-y-4">
            {filteredResources.map(resource => (
              <div
                key={resource.id}
                className={`bg-white rounded-xl shadow-lg p-4 transition-all ${
                  selectedResources.has(resource.id) ? 'ring-4 ring-blue-500' : 'hover:shadow-xl'
                }`}
              >
                <div className="flex gap-4">
                  {/* Selection Checkbox */}
                  <button
                    onClick={() => toggleResourceSelection(resource.id)}
                    className={`w-10 h-10 rounded flex items-center justify-center flex-shrink-0 ${
                      selectedResources.has(resource.id)
                        ? 'bg-blue-600 text-white'
                        : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                    }`}
                  >
                    {selectedResources.has(resource.id) && <Check className="w-5 h-5" />}
                  </button>

                  {/* Thumbnail */}
                  <img src={resource.thumbnail} alt={resource.title} className="w-32 h-24 object-cover rounded-lg flex-shrink-0" />

                  {/* Content */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-4 mb-2">
                      <div className="flex-1">
                        <h3 className="text-gray-900 mb-1">{resource.title}</h3>
                        <p className="text-gray-600 text-sm line-clamp-2">{resource.description}</p>
                      </div>
                      <div className={`px-2 py-1 rounded-full flex items-center gap-1 ${getTypeColor(resource.type)} flex-shrink-0`}>
                        {getTypeIcon(resource.type)}
                        <span className="text-xs capitalize">{resource.type}</span>
                      </div>
                    </div>

                    <div className="flex items-center gap-4 text-xs text-gray-500">
                      <div className="flex items-center gap-1">
                        <Tag className="w-3 h-3" />
                        {resource.category}
                      </div>
                      <div className="flex items-center gap-1">
                        <LinkIcon className="w-3 h-3" />
                        {resource.source}
                      </div>
                      {resource.duration && <div>{resource.duration}</div>}
                      {resource.pages && <div>{resource.pages} pages</div>}
                      <div>Added {resource.addedDate}</div>
                    </div>
                  </div>

                  {/* Actions */}
                  <div className="flex gap-2 flex-shrink-0">
                    <button
                      onClick={() => {
                        setEditingResource(resource);
                        setShowEditModal(true);
                      }}
                      className="px-3 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors flex items-center gap-2"
                    >
                      <Edit2 className="w-4 h-4" />
                      Edit
                    </button>
                    <button
                      onClick={() => handleDeleteResource(resource.id)}
                      className="px-3 py-2 bg-red-100 text-red-600 rounded-lg hover:bg-red-200 transition-colors"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Empty State */}
        {filteredResources.length === 0 && (
          <div className="text-center py-16 bg-white rounded-xl shadow-lg">
            <BookOpen className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-gray-900 mb-2">No resources found</h3>
            <p className="text-gray-600 mb-6">
              {searchQuery || selectedCategory !== 'All' 
                ? 'Try adjusting your filters' 
                : 'Start by adding your first resource'}
            </p>
            {!searchQuery && selectedCategory === 'All' && (
              <button
                onClick={() => setShowAddModal(true)}
                className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
              >
                <Plus className="w-4 h-4" />
                Add Resource
              </button>
            )}
          </div>
        )}
      </div>

      {/* Add Resource Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
              <h2 className="text-gray-900">Add New Resource</h2>
              <button onClick={() => setShowAddModal(false)} className="text-gray-400 hover:text-gray-600">
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className="p-6 space-y-4">
              {/* URL Input */}
              <div>
                <label className="block text-gray-700 mb-2">Resource URL *</label>
                <div className="relative">
                  <LinkIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <input
                    type="url"
                    placeholder="Paste link from 小红书, X, YouTube, etc."
                    value={newResource.url}
                    onChange={(e) => setNewResource({ ...newResource, url: e.target.value })}
                    className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>

              {/* Title */}
              <div>
                <label className="block text-gray-700 mb-2">Title *</label>
                <input
                  type="text"
                  placeholder="Enter resource title"
                  value={newResource.title}
                  onChange={(e) => setNewResource({ ...newResource, title: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              {/* Description */}
              <div>
                <label className="block text-gray-700 mb-2">Description</label>
                <textarea
                  placeholder="Brief description of the resource"
                  value={newResource.description}
                  onChange={(e) => setNewResource({ ...newResource, description: e.target.value })}
                  rows={3}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                />
              </div>

              {/* Type and Category */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-gray-700 mb-2">Type *</label>
                  <select
                    value={newResource.type}
                    onChange={(e) => setNewResource({ ...newResource, type: e.target.value as any })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="video">Video</option>
                    <option value="document">Document</option>
                    <option value="article">Article</option>
                  </select>
                </div>

                <div>
                  <label className="block text-gray-700 mb-2">Category *</label>
                  <select
                    value={newResource.category}
                    onChange={(e) => setNewResource({ ...newResource, category: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="">Select category</option>
                    {categories.filter(c => c !== 'All').map(cat => (
                      <option key={cat} value={cat}>{cat}</option>
                    ))}
                  </select>
                </div>
              </div>

              {/* Source and Duration/Pages */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-gray-700 mb-2">Source</label>
                  <input
                    type="text"
                    placeholder="e.g., 小红书, YouTube, X"
                    value={newResource.source}
                    onChange={(e) => setNewResource({ ...newResource, source: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>

                <div>
                  <label className="block text-gray-700 mb-2">
                    {newResource.type === 'video' ? 'Duration' : 'Pages'}
                  </label>
                  <input
                    type="text"
                    placeholder={newResource.type === 'video' ? 'e.g., 45min' : 'e.g., 85'}
                    value={newResource.type === 'video' ? newResource.duration : newResource.pages}
                    onChange={(e) => setNewResource({ 
                      ...newResource, 
                      [newResource.type === 'video' ? 'duration' : 'pages']: e.target.value 
                    })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
            </div>

            <div className="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
              <button
                onClick={() => setShowAddModal(false)}
                className="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleAddResource}
                disabled={!newResource.title || !newResource.url || !newResource.category}
                className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Add Resource
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Edit Resource Modal */}
      {showEditModal && editingResource && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
              <h2 className="text-gray-900">Edit Resource</h2>
              <button onClick={() => {
                setShowEditModal(false);
                setEditingResource(null);
              }} className="text-gray-400 hover:text-gray-600">
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className="p-6 space-y-4">
              <div>
                <label className="block text-gray-700 mb-2">Title *</label>
                <input
                  type="text"
                  value={editingResource.title}
                  onChange={(e) => setEditingResource({ ...editingResource, title: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div>
                <label className="block text-gray-700 mb-2">Description</label>
                <textarea
                  value={editingResource.description}
                  onChange={(e) => setEditingResource({ ...editingResource, description: e.target.value })}
                  rows={3}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-gray-700 mb-2">Category *</label>
                  <select
                    value={editingResource.category}
                    onChange={(e) => setEditingResource({ ...editingResource, category: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    {categories.filter(c => c !== 'All').map(cat => (
                      <option key={cat} value={cat}>{cat}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-gray-700 mb-2">Source</label>
                  <input
                    type="text"
                    value={editingResource.source}
                    onChange={(e) => setEditingResource({ ...editingResource, source: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
            </div>

            <div className="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
              <button
                onClick={() => {
                  setShowEditModal(false);
                  setEditingResource(null);
                }}
                className="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleUpdateResource}
                className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Add to Learning Path Modal */}
      {showAddToPathModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
              <div>
                <h2 className="text-gray-900">Add to Learning Path</h2>
                <p className="text-gray-600 text-sm mt-1">{selectedResources.size} resource(s) selected</p>
              </div>
              <button onClick={() => setShowAddToPathModal(false)} className="text-gray-400 hover:text-gray-600">
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className="p-6">
              <h3 className="text-gray-900 mb-4">Select Learning Path</h3>
              <div className="space-y-3">
                {learningPaths.map(path => (
                  <div key={path.id} className="border border-gray-200 rounded-lg p-4 hover:border-blue-500 transition-colors">
                    <div className="flex items-start justify-between mb-3">
                      <div>
                        <h4 className="text-gray-900">{path.title}</h4>
                        <p className="text-sm text-gray-600">{path.itemCount} items</p>
                      </div>
                      <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2">
                        <ArrowRight className="w-4 h-4" />
                        Select
                      </button>
                    </div>

                    {/* Position Selection */}
                    <div className="border-t border-gray-200 pt-3">
                      <label className="block text-sm text-gray-700 mb-2">Insert Position</label>
                      <select className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm">
                        <option value="end">At the end</option>
                        <option value="start">At the beginning</option>
                        <option value="after-1">After item #1</option>
                        <option value="after-2">After item #2</option>
                        <option value="after-3">After item #3</option>
                      </select>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div className="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
              <button
                onClick={() => setShowAddToPathModal(false)}
                className="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}