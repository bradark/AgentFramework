---
name: secure-resilient-code
description: Standards for secure and resilient code — input validation, secrets handling, injection prevention, error handling, timeouts, retries, and failure modes. Use whenever writing or reviewing code that handles input, I/O, network, auth, data storage, or external services.
---

# Secure and Resilient Code

Assume every input is hostile, every dependency fails, and every error will
eventually happen in production.

## Security

### Trust boundaries
- **Validate all external input** (user input, files, env vars, HTTP, queue
  messages, LLM output) at the boundary. Validate type, length, range, and format.
- Prefer allow-lists over deny-lists.
- Treat data from other services as untrusted even when the service is internal.

### Injection
- **Never build queries or commands by string concatenation.** Use parameterized
  queries, ORM bindings, and argument arrays (`subprocess.run([...])`, not `shell=True`).
- Encode output for its context (HTML, URL, shell, SQL). Use the framework's
  auto-escaping and never bypass it casually.
- Never `eval` or deserialize untrusted data with unsafe loaders (`pickle`,
  `yaml.load`, `BinaryFormatter`).
- Canonicalize file paths and check that they stay inside the allowed root, to
  prevent path traversal.

### Secrets
- **No secrets in code, logs, error messages, URLs, or commits.** Load them from
  environment variables or a secret manager.
- Don't log full request bodies, tokens, passwords, or PII. Redact them.
- If you find a committed secret, flag it to the human. Rotating it is a human decision.

### AuthN / AuthZ
- Check authorization on **every** request, server-side. Never rely on the UI
  hiding a button.
- Deny by default. Grant least privilege, both to code and to service accounts.
- Use vetted libraries for crypto, auth, and sessions. **Never roll your own crypto.**
- Compare secrets in constant time.

### Dependencies
- Don't add a dependency for something trivial. Each one adds attack surface.
- Pin versions and prefer well-maintained packages. Check that the package name
  is real (typosquatting) before installing.

## Resilience

### Errors
- **Never swallow exceptions silently.** Handle the error, or add context and
  re-raise it.
- Catch specific exceptions, not bare `catch` or `except Exception`, unless you
  are at a top-level boundary.
- Fail fast on programmer errors. Degrade gracefully on environmental errors.
- Error messages for users must be safe. Error logs for operators must be useful
  (include IDs and context, but no secrets).

### External calls
- **Every network or I/O call has a timeout.** There are no unbounded waits.
- Retry only idempotent operations, using exponential backoff with jitter and a cap.
- Use circuit breakers or bulkheads where a failing dependency could cascade.
- Design operations to be idempotent where possible (idempotency keys, upserts).

### Resources and state
- Always release resources: `with`, `using`, `try/finally`, `defer`.
- Bound everything: queue sizes, batch sizes, pagination, memory, and recursion depth.
- Watch for race conditions. Use the language's concurrency primitives correctly,
  and prefer immutability.
- Validate config at startup and refuse to start if it's invalid.

### Observability
- Log at the right level with structured fields. You should be able to
  diagnose a failure from the logs alone.

## Self-check before you finish
- [ ] Where does untrusted data enter, and is it validated there?
- [ ] Can any input reach a query, shell, path, or template unescaped?
- [ ] What happens when each external call times out or fails?
- [ ] Is anything sensitive logged or returned?
