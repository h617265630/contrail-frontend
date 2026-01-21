import sys
from pathlib import Path

# Ensure backend dir is on sys.path so we can import project modules
BASE_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BASE_DIR))

from app.core.config import settings
import psycopg2

url = getattr(settings, 'DATABASE_URL', None)
print('DATABASE_URL:', url)
if not url:
    print('No DATABASE_URL available')
    sys.exit(1)

try:
    conn = psycopg2.connect(url)
    conn.autocommit = True
    cur = conn.cursor()

    print('\n-- public schema tables:')
    cur.execute("SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY tablename")
    rows = cur.fetchall()
    for r in rows:
        print(' -', r[0])

    print('\n-- check link_resources exists:')
    cur.execute("SELECT to_regclass('public.link_resources')")
    exists = cur.fetchone()[0]
    print('link_resources:', exists)

    print('\n-- alembic_version contents:')
    try:
        cur.execute('SELECT * FROM alembic_version')
        for r in cur.fetchall():
            print(r)
    except Exception as e:
        print('Could not read alembic_version:', e)

    cur.close()
    conn.close()
except Exception as e:
    print('DB connection error:', repr(e))
    sys.exit(2)
