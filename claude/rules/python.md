---
paths:
  - "**/*.py"
---

# Python Standards

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
