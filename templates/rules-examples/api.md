---
paths:
  - "app/controllers/api/**/*"
  - "src/api/**/*"
  - "routes/**/*"
---

# API rules

- Controllers are thin — one service call per action, nothing else
- Always return consistent JSON: `{ success: true, data: ... }` or `{ success: false, error: ... }`
- Use proper HTTP status codes — 201 for create, 204 for delete, 422 for validation errors
- Paginate all list endpoints — never return unbounded arrays
- Version the API — `/api/v1/` prefix
- Document with request/response examples in comments or swagger specs
