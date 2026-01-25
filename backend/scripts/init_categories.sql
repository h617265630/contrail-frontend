-- 初始化默认分类数据
-- 使用 ON CONFLICT DO NOTHING 避免重复插入

INSERT INTO categories (name, code, level, is_leaf, is_system, owner_user_id, description)
VALUES 
    ('AI', 'ai', 0, true, true, NULL, 'AI 相关资源'),
    ('设计', 'design', 0, true, true, NULL, '设计相关资源'),
    ('UI', 'ui', 0, true, true, NULL, 'UI 设计相关资源'),
    ('前端', 'frontend', 0, true, true, NULL, '前端开发相关资源'),
    ('后端', 'backend', 0, true, true, NULL, '后端开发相关资源'),
    ('手工', 'handmade', 0, true, true, NULL, '手工制作相关资源'),
    ('其他', 'other', 0, true, true, NULL, '其他类型资源')
ON CONFLICT (code) DO NOTHING;

-- 查询结果验证
SELECT id, name, code, is_system, owner_user_id FROM categories ORDER BY id;
