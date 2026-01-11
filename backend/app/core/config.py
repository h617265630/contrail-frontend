"""
Centralized application configuration.

Loads environment variables (via python-dotenv if available) and provides
typed settings with sensible defaults for local development.
"""

import os
from dataclasses import dataclass

try:
	# Optional: load .env if available
	from dotenv import load_dotenv
	load_dotenv()
except Exception:
	pass


@dataclass
class Settings:
	# Database
	DATABASE_URL: str = os.environ.get(
		"DATABASE_URL",
		"postgresql://postgres:burnme@localhost/db",
	)
	SQL_ECHO: bool = os.environ.get("SQL_ECHO", "true").lower() in {"1", "true", "yes", "on"}

	# Auth / Security
	SECRET_KEY: str = os.environ.get("SECRET_KEY", "dev-secret-change-me")
	ALGORITHM: str = os.environ.get("ALGORITHM", "HS256")
	ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.environ.get("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))


# Singleton settings instance
settings = Settings()

