#!/usr/bin/env python3
"""
为学习路径 ID=7 添加测试资源
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
        print("=" * 60)
        print("为学习路径 ID=7 添加测试资源")
        print("=" * 60)
        
        # 首先检查是否有可用的资源
        result = conn.execute(text("""
            SELECT id, title, resource_type
            FROM resources
            ORDER BY id DESC
            LIMIT 10
        """))
        resources = result.fetchall()
        
        if not resources:
            print("❌ 数据库中没有任何资源，无法添加到学习路径")
            return
        
        print(f"\n找到 {len(resources)} 个可用资源:")
        for r in resources:
            print(f"  - ID={r[0]}, type={r[1]}, title={r[2]}")
        
        # 选择前5个资源添加到学习路径
        selected_resources = resources[:min(5, len(resources))]
        
        print(f"\n将添加 {len(selected_resources)} 个资源到学习路径 ID=7...")
        
        added_count = 0
        for idx, res in enumerate(selected_resources):
            try:
                conn.execute(text("""
                    INSERT INTO path_items (
                        learning_path_id, resource_id, order_index, 
                        stage, purpose, estimated_time, is_optional
                    ) VALUES (
                        :learning_path_id, :resource_id, :order_index,
                        NULL, NULL, NULL, FALSE
                    )
                """), {
                    "learning_path_id": 7,
                    "resource_id": res[0],
                    "order_index": idx + 1
                })
                conn.commit()
                print(f"  ✅ 添加资源 ID={res[0]} (order={idx + 1})")
                added_count += 1
            except Exception as e:
                print(f"  ⚠️  添加资源 ID={res[0]} 失败: {e}")
                conn.rollback()
                continue
        
        print(f"\n" + "=" * 60)
        print(f"✅ 成功添加 {added_count} 个资源到学习路径")
        print("=" * 60)
        
        # 验证
        result = conn.execute(text("""
            SELECT pi.id, pi.resource_id, pi.order_index, r.title
            FROM path_items pi
            LEFT JOIN resources r ON r.id = pi.resource_id
            WHERE pi.learning_path_id = 7
            ORDER BY pi.order_index
        """))
        items = result.fetchall()
        
        print(f"\n当前学习路径 ID=7 共有 {len(items)} 个内容项:")
        for item in items:
            print(f"  - Order={item[2]}, Resource ID={item[1]}, Title={item[3]}")
        
        print("\n" + "=" * 60)
        print("🎉 完成！现在可以在前端查看路径内容了")
        print("=" * 60)

if __name__ == "__main__":
    main()
