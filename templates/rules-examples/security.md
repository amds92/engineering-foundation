---
paths:
  - "app/controllers/**/*"
  - "src/api/**/*"
  - "app/Http/Controllers/**/*"
---

# Security rules

- Every endpoint requires authentication unless explicitly public
- Authorise by resource, not just by role — check ownership
- Never trust user input — validate and sanitise at the boundary
- Never interpolate user input into SQL — use parameterised queries or ORM
- Never log sensitive data — no passwords, tokens, card numbers in logs
- Rate limit all public endpoints
- Use `strong_parameters` / input schemas — never pass raw params to models
