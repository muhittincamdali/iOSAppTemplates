# CleanArchitectureApp

Clean Architecture template: a SwiftUI app for iOS 18 with Directory, Summary and Settings
tabs, split into Domain, Data and Presentation targets.

The app is a team directory. You can search, filter and sort people, edit a profile, change
roles and deactivate accounts, with the rules enforced in use cases. It talks HTTP to an
in-process sample server and keeps the last directory in a file, so it also works offline.
Swap the sample server for `URLSessionHTTPClient` and your base URL to use a real backend.

## Layers

Each layer is its own target, so the compiler enforces the dependency rule: a file in
Presentation cannot import Data, and Domain imports nothing but Foundation.

```text
CleanArchitectureApp (composition root)
├── CleanArchitectureAppPresentation ──┐
├── CleanArchitectureAppData ──────────┤
└──────────────────────────────────────┴──> CleanArchitectureAppDomain
```

| Target                             | Contents                                                                                                                                                                                                                                                         |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CleanArchitectureAppDomain`       | `User`, `UserRole` and `Permission`; `ProfileDraft` validation; `UserQuery` search, filter and sort; the `UserRepository` protocol and `DirectoryError`; the use cases `ListUsersUseCase`, `UpdateProfileUseCase` and `SetUserActiveUseCase`                     |
| `CleanArchitectureAppData`         | `UsersAPI` (two endpoints and the mapping from HTTP status to `DirectoryError`), `UserDTO`, `HTTPClient` with `URLSessionHTTPClient`, `FileUserCache` and `InMemoryUserCache`, `DefaultUserRepository` (server first, saved copy as fallback) and `SampleServer` |
| `CleanArchitectureAppPresentation` | `@Observable` models (`DirectoryModel`, `ProfileEditorModel`, `SettingsModel`) and the SwiftUI screens; user-facing messages for every domain error                                                                                                              |
| `CleanArchitectureApp`             | `CleanArchitectureAppContainer`, which builds the object graph, and `CleanArchitectureAppShell`, the public `App`                                                                                                                                                |

## Rules the use cases enforce

- Members edit only their own profile; admins edit anyone and are the only ones who change
  roles or activate and deactivate accounts.
- Moderators and admins also see deactivated accounts. A deactivated account keeps its role but
  loses every permission, and permissions are read from the freshly loaded record.
- The last active admin cannot be demoted or deactivated.
- Names are 2 to 60 characters after whitespace is collapsed, and may not contain control or
  bidirectional override characters. Email addresses are lowercased and checked against the
  RFC 5321 length limits. The server stays the final authority, and a real server must enforce
  the same permissions, because a client can always be modified.

## Data flow

- `GET /v1/users` returns the directory and replaces the saved copy. When the server cannot be
  reached or answers with a 5xx status, the saved copy is shown with the time it was saved;
  `401`, `403`, `404` and unreadable responses are reported instead of hidden.
- `PUT /v1/users/{id}` saves a change; `409` with `{"error": "email_taken"}` means another
  account uses the address. A successful save also updates the saved copy.
- Records with a role this app version does not know are left out instead of failing the load.
- The saved copy is a JSON file in `Library/Caches`, written atomically and, on iOS, protected
  until the device is first unlocked.

## Test

```bash
xcodebuild test -scheme CleanArchitectureApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

`iPhone 17` is an example; use any simulator that `xcrun simctl list devices available` lists.
The four test targets cover the domain rules and validation edge cases, HTTP status mapping and
the cache fallback, the screen models (including a slow response that arrives after a newer one)
and the whole object graph end to end, including an edit that survives an offline relaunch.

`App/UITests` drives the built app with XCUITest: diacritic-insensitive search, the offline
fallback after the server is switched off on the Settings tab, and an accessibility audit
(`performAccessibilityAudit`) of the Directory tab. The audit skips the contrast check, which
reports the system's secondary label colour as "nearly passed", and the clipping report for the
system-drawn search field. Run them from the host project:

```bash
cd App
xcodegen generate
xcodebuild test -project CleanArchitectureApp.xcodeproj -scheme CleanArchitectureAppHost \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Run

```bash
cd App
xcodegen generate
open CleanArchitectureApp.xcodeproj
```

In the app, open **Settings** and turn off **Server reachable**; the directory reloads and the
Directory tab shows the saved copy with the time it was saved. Pick another person under **Signed in as** to see what a
member or a moderator may do.

## Use your own server

`CleanArchitectureAppShell` builds its object graph with `CleanArchitectureAppContainer.sample()`
in `Sources/CleanArchitectureApp/CleanArchitectureApp.swift`. Replace that call with
`CleanArchitectureAppContainer(client:baseURL:cache:controls:actingUserID:)`, passing
`URLSessionHTTPClient()`, your server's base URL, a `FileUserCache` at
`CleanArchitectureAppContainer.defaultCacheURL` and the id of the signed-in user. Your server
needs the two endpoints above with the same JSON (snake_case keys, ISO 8601 dates).

`BackendControls` drives the switches on the Settings tab. Implement it for your backend, or
remove the Sample server section and pass a type that does nothing.
