# Development Guidelines

## Core Principles
- **KISS above all** - Simple solutions always win
- **Incremental progress** - Small changes that compile and pass tests
- **Never assume** - If critical information is missing (e.g., DB schema), ask for clarification
- **Learn from existing code** - Study patterns in the repo before implementing
- **Clear intent over clever code** - Be boring and obvious
- **When in doubt, ask** - If unsure between approaches, propose 1-3 options and let me decide
- **Challenge the premise** - Push back if the approach seems wrong, even if I suggested it
 
### Decision Framework
When choosing between approaches, prioritize:
1. Simplicity
2. Testability
3. Readability (will someone understand in 6 months?)
4. Consistency with project patterns

## Workflow
- Clean up any temporary files or scripts created during iteration

## Guardrails
- Never perform destructive operations (force push, rm -rf, DROP/DELETE/TRUNCATE, DB writes) without explicit approval 
- Never modify CI/CD configs, deployment scripts, or env files without asking
- No dependency version changes without confirming with me. If the repo already uses the dependency, reuse the existing version.

## Python Standards
- Target Python 3.13+
- Use f-strings for all string formatting (consistency across codebase; .format() and % are banned)
- Prefer built-in types (dict, list, tuple) over typing imports
- Public interfaces require type hints; internals optional when obvious
- Use dataclasses for value objects
- Imports at top of file; local imports only to break circular deps or for optional/heavy modules

## Error Handling
- Before adding `try/except`, trace the call chain. If it surfaces cleanly at a boundary, don't catch mid-stack.
- Catch specific exceptions in core logic. Broad `Exception` only at true boundaries (API handler, job runner) for response/retry/fail decisions.
- Bare `raise` to re-raise; `raise DomainError(...) from e` only when translating to a meaningful domain error. Avoid multi-layer wrapping.
- Never swallow exceptions. No `except: pass`, no "log and continue" without an explicit documented fallback.
- Error messages must include actionable debugging context. Generic messages are banned.
- Log once at the boundary with full context and correlation IDs (for Datadog). Inner layers raise enriched exceptions instead of logging.

## Testing
- Test behavior, not implementation
- One assertion per test - each test verifies one behavior, not multiple outcomes. Keep tests short and sweet
- Keep mocking simple; if test setup is complex, refactor the code instead
- Write the fewest tests needed to cover core logic

## Documentation
- Comment only: non-obvious things, business rules, why-not-what decisions, workarounds with issue numbers

## Before Every Commit
- No commented-out code or dead code (unused imports, functions, variables)
- Run all relevant tests using the Bash subagent only
- Commit message explains why, not what

## Database Access
- Read-only PostgreSQL access via `psql` when `CLAUDE_DATABASE_URL` is set in the project's `.claude/settings.json` env block
- For multi-env projects: `CLAUDE_DATABASE_STAGING_URL` and `CLAUDE_DATABASE_PROD_URL`. Prefer staging unless asked for prod.
- Always check the project's data access layer first before querying directly
- Query format: `psql "$CLAUDE_DATABASE_URL" -c "SELECT ..."`

## Tools
- Use the Context7 MCP server to fetch current library docs before using unfamiliar APIs
