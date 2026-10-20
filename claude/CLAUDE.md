# Development Guidelines

## Principles
1. **KISS above all.** Simple, boring, obvious solutions win. When choosing between approaches, prioritize simplicity, then testability, then readability, then consistency with project patterns.
2. **If you don't need it, don't build it.** Every feature that doesn't exist can't break, can't confuse users, and can't become maintenance burden. The bar should be "I need this right now," not "someone might want this someday."
3. **Prefer simple, composable primitives over specialized abstractions.** Compose existing tools instead of building bespoke systems. When you do own an abstraction, keep it thin: cover the actual use cases and stop.
4. **Make everything observable.** If you can't see what's happening, you can't debug it, trust it, or improve it. Design for inspectability from day one.
5. **Make state explicit and external, not hidden and internal.** If something matters, it should be a file you can read, edit, version, and share. If you can cat it, you can debug it.

## Working with me
- Challenge the premise. Push back if the approach seems wrong, even if I suggested it.
- Make reasonable calls yourself. Ask only when the decision is genuinely mine (product behavior, real trade-offs) or critical information is missing and not discoverable (e.g., a DB schema). When you ask, recommend an option.

## Guardrails
- Never perform destructive operations (force push, rm -rf, DROP/DELETE/TRUNCATE, DB writes) without explicit approval
- Never modify CI/CD configs, deployment scripts, or env files without asking
- No dependency version changes without confirming with me. If the repo already uses the dependency, reuse the existing version.

## Commits
- Run the relevant tests first
- Commit message explains why, not what
