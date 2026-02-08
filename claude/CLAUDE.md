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
- If unsure between approaches, propose 2 options and ask me to pick
- Clean up any temporary files or scripts created during iteration

## Guardrails
- Never perform destructive operations (force push, rm -rf, DROP/DELETE/TRUNCATE, DB writes) without explicit approval 
- Never modify CI/CD configs, deployment scripts, or env files without asking
- No dependency version changes without confirming with me. If the repo already uses the dependency, reuse the existing version.

## Python Standards
- Target Python 3.13+
- Follow PEP8 strictly
- Use f-strings for all string formatting (consistency across codebase; .format() and % are banned)
- Prefer built-in types (dict, list, tuple) over typing imports
- Public interfaces require type hints; internals optional when obvious
- Use dataclasses for value objects
- Imports at top of file; local imports only to break circular deps or for optional/heavy modules

## Error Handling
- Never catch broad exceptions (Exception, BaseException) unless re-raising. Catch the specific exception type.
- Always use `raise ... from e` to preserve the exception chain. Never bare `raise` or `raise NewError("msg")` without `from`.
- Before adding try/except, trace the full call chain: what raises, what catches, and where it surfaces. If an exception will already propagate to a reasonable handler, don't catch it.
- Never silently swallow exceptions. No bare `except: pass`, no `except Exception: log.warning(...)` without re-raising.
- Error messages must include the specific context that failed: the input, the ID, the filename. "Failed to process record" is banned;
- When writing a function that calls external services or I/O, explicitly consider: what happens if this times out, returns None, or raises? Don't leave the sad path to chance.

## Testing
- Test behavior, not implementation
- One assertion per test - each test verifies one behavior, not multiple outcomes. Keep tests short and sweet
- Keep mocking simple; if test setup is complex, refactor the code instead
- Descriptive names: `test_handles_empty_input_gracefully`
- Tests must be deterministic
- Write the fewest tests needed to cover core logic

## Documentation
- Comment only: non-obvious things, business rules, why-not-what decisions, workarounds with issue numbers
- Keep comments concise. Update when modifying code; remove if outdated.

## Before Every Commit
- No commented-out code or dead code (unused imports, functions, variables)
- Run all relevant tests using the Bash subagent only
- Commit message explains why, not what

## Tools
- Use the Context7 MCP server to fetch current library docs before using unfamiliar APIs
