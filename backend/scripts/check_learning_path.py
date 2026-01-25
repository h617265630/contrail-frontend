#!/usr/bin/env python3
"""
检查学习路径数据
"""

import sys
from pathlib import Path

backend_dir = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(backend_dir))

from app.core.config import settings
from sqlalchemy import create_engine, text

def main():
    engine = create_engine(settings.DATABASE_URL)
    
    with engine.connect() as conn:
        # 检查学习路径 ID=7
        print("=" * 60)
        print("检查学习路径 ID=7")
        print("=" * 60)
        
        result = conn.execute(text("""
            SELECT id, title, description, is_public, is_active, category_id
            FROM learning_paths
            WHERE id = 7
        """))
        lp = result.fetchone()
        
        if not lp:
            print("❌ 未找到学习路径 ID=7")
            
            # 查看所有学习路径
            print("\n当前数据库中的所有学习路径:")
            result = conn.execute(text("""
                SELECT id, title, is_public, is_active
                FROM learning_paths
                ORDER BY id
            """))
            paths = result.fetchall()
            if paths:
                for p in paths:
                    print(f"  - ID={p[0]}, title={p[1]}, is_public={p[2]}, is_active={p[3]}")
            else:
                print("  (数据库中没有任何学习路径)")
            return
        
        print(f"✅ 找到学习路径:")
        print(f"  - ID: {lp[0]}")
        print(f"  - 标题: {lp[1]}")
        print(f"  - 描述: {lp[2]}")
        print(f"  - 公开: {lp[3]}")
        print(f"  - 激活: {lp[4]}")
        print(f"  - 分类ID: {lp[5]}")
        
        # 检查 path_items
        print("\n" + "=" * 60)
        print("检查路径内容 (path_items)")
        print("=" * 60)
        
        result = conn.execute(text("""
            SELECT pi.id, pi.resource_id, pi.order_index, r.title, r.resource_type
            FROM path_items pi
            LEFT JOIN resources r ON r.id = pi.resource_id
            WHERE pi.learning_path_id = 7
            ORDER BY pi.order_index
        """))
        items = result.fetchall()
        
        if not items:
            print("⚠️  该学习路径没有任何内容（path_items 为空）")
            print("\n这就是前端无法显示路径内容的原因！")
        else:
            print(f"✅ 找到 {len(items)} 个路径内容项:")
            for item in items:
                print(f"  - PathItem ID={item[0]}, Resource ID={item[1]}, Order={item[2]}")
                print(f"    标题: {item[3]}")
                print(f"    类型: {item[4]}")
        
        # 检查用户关联
        print("\n" + "=" * 60)
        print("检查用户关联 (user_learning_path)")
        print("=" * 60)
        
        result = conn.execute(text("""
            SELECT ulp.user_id, u.username
            FROM user_learning_path ulp
            LEFT JOIN users u ON u.id = ulp.user_id
            WHERE ulp.learning_path_id = 7
        """))
        users = result.fetchall()
        
        if users:
            print(f"✅ 该路径已被 {len(users)} 个用户使用:")
            for u in users:
                print(f"  - User ID={u[0]}, username={u[1]}")
        else:
            print("⚠️  该路径还没有被任何用户使用")

if __name__ == "__main__":
    main()
