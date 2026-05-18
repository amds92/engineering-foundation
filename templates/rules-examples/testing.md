---
paths:
  - "spec/**/*"
  - "tests/**/*"
  - "__tests__/**/*"
---

# Testing rules

- Use doubles/mocks for all external dependencies — no real HTTP calls in unit tests
- Test behaviour, not implementation — never test private methods
- Every service/use-case needs: success path, failure path, and edge cases
- Factory or fixture data only — never hardcode IDs or magic strings
- One `describe` block per class, one `context` per scenario
- Test file mirrors source file structure
