# Development Guidelines

## Core Principles

### Fundamental Philosophy
- **KISS above all** - Simple solutions always win
- **Incremental progress** - Small changes that compile and pass tests
- **Learn from existing code** - Study patterns before implementing
- **Clear intent over clever code** - Be boring and obvious
- **Never assume** - If critical information is missing (e.g., DB schema), ask for clarification

### Decision Framework
When choosing between approaches, prioritize:
1. **Testability** - Can I easily test this?
2. **Readability** - Will someone understand in 6 months?
3. **Consistency** - Does it match project patterns?
4. **Simplicity** - Is this the simplest working solution?
5. **Reversibility** - How hard to change later?

## Python Standards

### Language Requirements
- Target Python 3.12
- Follow PEP8 strictly
- Use f-strings for all string formatting
- Prefer built-in types (dict, list, tuple) over typing imports
- Public interfaces require type hints; internals optional when obvious
- Use dataclasses for value objects

## Implementation Process

### Complex Work Planning
For multi-stage work, document in `IMPLEMENTATION_PLAN.md`:

```markdown
## Stage N: [Name]
**Goal**: [Specific deliverable]
**Success Criteria**: [Testable outcomes]
**Tests**: [Specific test cases]
**Status**: [Not Started|In Progress|Complete]
```

### Development Flow
1. **Understand** - Study existing patterns
2. **Test** - Write test first (red)
3. **Implement** - Minimal code to pass (green)
4. **Refactor** - Clean up with tests passing
5. **Commit** - Clear message linking to plan

### Stuck Protocol
Maximum 3 attempts per issue, then:
1. Document failures with specific errors
2. Research 2-3 alternative approaches
3. Question if solving the right problem
4. Try fundamentally different angle

## Code Design

### Architecture Principles
- **Composition over inheritance** - Use dependency injection
- **Explicit over implicit** - Clear data flow
- **Fail fast** - Early validation with clear errors
- **Make illegal states unrepresentable** - Use types to prevent bugs

### Error Handling
- Always handle expected failure modes with clear, actionable error messages.

## Testing

### Test Philosophy
- Test behavior, not implementation
- Use descriptive names: `test_handles_empty_input_gracefully`
- Tests must be deterministic
- Keep tests and mocking (when needed) simple; if complex, refactor the code instead
- Write the fewest unit tests needed to cover the core logic of a class or method.

## Documentation

### When to Comment
- Non-obvious algorithms or business rules
- Why decisions were made (not what code does)
- Temporary workarounds with issue numbers
- Complex regex or performance optimizations
- Keep comments concise. Update when modifying code; remove if outdated.

## Quality Control

### Before Every Commit
- All tests pass
- No linter warnings
- Code follows project patterns
- Commit message explains why, not what
- No commented-out code
