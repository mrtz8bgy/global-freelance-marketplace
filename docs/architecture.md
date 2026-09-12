# Architecture

The project uses a public-document-root PHP front controller. Application code, storage, database migrations and tests remain outside `public/`. Controllers coordinate HTTP concerns, models own persistence, and services isolate payment, search, reputation and notifications. External payment providers should be integrated through `PaymentService` adapters and webhooks must be idempotent.
