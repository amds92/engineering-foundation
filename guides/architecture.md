# Architecture Principles

Language-agnostic principles for building systems that last.

## The core question before writing any code

> "What kind of thing is this?"

| It is... | It becomes... |
|----------|--------------|
| Business logic with multiple steps | Service object / Use case |
| Slow, async, or retriable work | Background job |
| Scheduled, recurring work | Cron job |
| External API communication | Client / Adapter |
| Data transformation | Value object / DTO |
| HTTP request/response | Controller (thin) |
| Shared behaviour across classes | Concern / Mixin / Decorator |
| Data persistence rules | Model (no business logic) |
| Complex query | Query object |
| Notification/email/webhook | Notifier / Mailer |

## Separation of concerns

Each piece of code should have one reason to change.

**Controllers** receive HTTP, call a service, return HTTP. Nothing else.
```
# Good
def create
  result = CreateUser.call(user_params)
  result.success? ? render_created(result.payload) : render_error(result.error)
end

# Bad — business logic in controller
def create
  user = User.new(user_params)
  user.role = "admin" if current_user.super_admin?
  user.send_welcome_email if user.save
  render json: user
end
```

**Services / Use cases** hold business logic. They know nothing about HTTP.

**Models** define data structure and relationships. They do not orchestrate workflows.

**Jobs** execute async work. They call services — they don't contain business logic themselves.

**Clients** talk to external APIs. All external calls go through a client, never inline.

## The duplication rule

Before creating anything new — **search first**.

- Is there a service that already does part of this?
- Is there a utility method that covers this?
- Is there a pattern already established?

Duplication is the most common form of technical debt. It multiplies the places you need to change when requirements evolve.

## The complexity rule

If you need to explain what a function does, it's too complex. Split it.

A function should do one thing. If it does two things, make two functions.

## Error handling

Every integration point has a failure path.

- External API calls can fail — handle the error, don't let it propagate uncaught
- Database operations can fail — transactions where needed, clear error messages
- Background jobs can fail — make them idempotent, use retries with backoff
- User input is always untrusted — validate at the boundary

## Performance

- Never load what you don't need (select only the columns required)
- Never make N queries when 1 will do (preload associations)
- Never do in a request what can be done in a job
- Never do synchronously what can be done asynchronously
- Paginate everything that returns lists

## Testing

- Unit tests test a single class in isolation — no real database, no real HTTP
- Integration tests test the flow end-to-end — real database, mocked HTTP
- If something is hard to test, the design is probably wrong

## When to use a background job

- Sending emails or notifications
- Calling external APIs
- Processing files or images
- Generating reports
- Anything that takes > 500ms
- Anything that can be retried independently
