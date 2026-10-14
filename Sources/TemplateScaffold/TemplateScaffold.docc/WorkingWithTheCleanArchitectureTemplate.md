# Working with the Clean Architecture Template

Build on the layered template: where code goes, how the layers talk, and how to connect your
own server.

## Overview

`CleanArchitectureApp` is the one template that is split into several targets. It is a team
directory with Directory, Summary and Settings tabs that loads people over HTTP, falls back to
a saved copy when offline, and enforces who may edit, promote or deactivate whom.

Create your own copy as with any other template:

```bash
swift run create-ios-app new TeamDirectory --template clean-architecture --output ~/Developer
```

Every target and type is renamed, so `CleanArchitectureAppDomain` becomes
`TeamDirectoryDomain` and `CleanArchitectureAppShell` becomes `TeamDirectoryShell`. The rest
of this article uses the template's own names.

### The dependency rule

Each layer is a target in `Package.swift`, and a target can import only the targets it
depends on:

| Target                             | May import | Holds                                                    |
| ---------------------------------- | ---------- | -------------------------------------------------------- |
| `CleanArchitectureAppDomain`       | Foundation | Entities, validation, the repository protocol, use cases |
| `CleanArchitectureAppData`         | Domain     | HTTP, JSON, the cache and the repository implementation  |
| `CleanArchitectureAppPresentation` | Domain     | `@Observable` models and SwiftUI views                   |
| `CleanArchitectureApp`             | all three  | The composition root and the `App` scene                 |

Because Presentation does not depend on Data, a view that tries to use `UsersAPI` does not
compile. When a screen needs something from outside the domain, such as the switches on the
Settings tab, Presentation declares a protocol (`BackendControls`) and the composition root
implements it.

### Adding a feature

Work from the inside out:

1. **Domain.** Add the rule as a use case, for example a `TransferOwnershipUseCase` next to
   `UpdateProfileUseCase` in `UseCases.swift`. It receives the acting user and throws a
   `DirectoryError` when the action is not allowed. If it needs new data, add a method to the
   `UserRepository` protocol. Test it with an in-memory repository; the existing tests in
   `Tests/CleanArchitectureAppDomainTests` show the pattern.
2. **Data.** Implement the new repository method in `DefaultUserRepository`, add the endpoint
   to `UsersAPI` and map its status codes to `DirectoryError` in `UsersAPI.map(statusCode:body:)`.
   Teach `SampleServer` the same endpoint so the app keeps running without a backend.
3. **Presentation.** Give the model a method that calls the use case and stores the result or
   the error, then add the control to a view. Models receive use cases, never repositories.
4. **Composition root.** Create the use case in `CleanArchitectureAppContainer` and pass it to
   the model.

### Connecting your own server

`CleanArchitectureAppShell` creates its object graph with
`CleanArchitectureAppContainer.sample()`. Replace that call with
`CleanArchitectureAppContainer(client:baseURL:cache:controls:actingUserID:)` and pass a
`URLSessionHTTPClient`, the base URL of your server, a `FileUserCache` and the id of the
signed-in user. The server needs two endpoints:

- `GET /v1/users` returns `{"users": [...]}`.
- `PUT /v1/users/{id}` takes one user and returns the stored version, or `409` with
  `{"error": "email_taken"}` when another account uses the address.

Users are JSON objects with `id`, `full_name`, `email`, `role`, `is_active` and `joined_at`
(ISO 8601). The client checks permissions to decide what to show, but a modified client can
skip those checks, so the server must enforce the same rules.

### What the tests cover

The template has one test target per layer and one for the whole graph:

- `CleanArchitectureAppDomainTests`: permissions, the last-admin rule, name and email
  validation at its limits, search, filter and sort.
- `CleanArchitectureAppDataTests`: status-code mapping, decoding, the cache file and the
  fallback rules, against a stub client and the sample server.
- `CleanArchitectureAppPresentationTests`: the screen models, including a response that
  arrives after a newer one.
- `CleanArchitectureAppTests`: the real object graph with a temporary cache file, including an
  edit that survives an offline relaunch.

Run them with `xcodebuild test -scheme CleanArchitectureApp` and an iOS Simulator destination.
