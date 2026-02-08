# Database Access

- Read-only PostgreSQL access via `psql` when `CLAUDE_DATABASE_URL` is set in the project's `.claude/settings.json` env block
- For multi-env projects: `CLAUDE_DATABASE_STAGING_URL` and `CLAUDE_DATABASE_PROD_URL`. Prefer staging unless asked for prod.
- Always check the project's data access layer first before querying directly
- Query format: `psql "$CLAUDE_DATABASE_URL" -c "SELECT ..."`
- In Postgres system views (`pg_stat_user_tables`, `pg_class`, etc.), the table name column is `relname`, not `table_name`
