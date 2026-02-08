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
- Never perform destructive operations (force push, rm, rm -rf, DROP/DELETE/TRUNCATE, DB writes) without explicit approval
- Never modify CI/CD configs, deployment scripts, or env files without asking
- No dependency version changes without confirming with me. If the repo already uses the dependency, reuse the existing version.

## Documentation
- Comment only: non-obvious things, business rules, why-not-what decisions, workarounds with issue numbers

## Before Every Commit
- No commented-out code or dead code (unused imports, functions, variables)
- Run all relevant tests using the Bash subagent only
- Commit message explains why, not what

## Tools
- Use the Context7 MCP server to fetch current library docs before using unfamiliar APIs
