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

## Engineering Principles
1. **If you don't need it, don't build it.** Every feature that doesn't exist can't break, can't confuse users, and can't become maintenance burden. The bar should be "I need this right now," not "someone might want this someday."
2. **Prefer simple, composable primitives over specialized abstractions.** Instead of bespoke systems, compose existing tools. A pipeline of simple, well-understood primitives almost always beats a monolithic "smart" one.
3. **Make everything observable.** If you can't see what's happening, you can't debug it, trust it, or improve it. Design for full inspectability from day one rather than bolting it on later.
4. **Own your abstractions, but keep them thin.** When third-party libraries cost you more time than writing your own thin layer, write your own. But cover your actual use cases and stop — resist the urge to make it "complete."
5. **Make state explicit and external, not hidden and internal.** If something matters, it should be a file you can read, edit, version, and share — not ephemeral state trapped inside a running process. If you can cat it, you can debug it.

## Workflow
- Clean up any temporary files or scripts created during iteration

## Guardrails
- Never perform destructive operations (force push, rm, rm -rf, DROP/DELETE/TRUNCATE, DB writes) without explicit approval
- Never modify CI/CD configs, deployment scripts, or env files without asking
- No dependency version changes without confirming with me. If the repo already uses the dependency, reuse the existing version.

## Documentation
- Comment only: non-obvious things, business rules, why-not-what decisions, workarounds with issue numbers

## Before Every Commit
- No commented-out code or dead code (unused imports, functions, variables)
- Run all relevant tests using the Bash subagent only
- Commit message explains why, not what

## Rules
- See @claude/rules/testing.md for testing standards
- See @claude/rules/database.md for database access patterns
- See @claude/rules/python.md for Python standards (applies to `*.py` files only)

