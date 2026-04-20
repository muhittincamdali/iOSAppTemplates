# API

This page does not describe an imagined generator-style API. It routes to the real public surface that exists in the repository today.

Canonical sources:

- [API Reference](./API-Reference.md)
- [Architecture API](./ArchitectureAPI.md)

Current public truth:

- there is a root package discovery surface
- there are template-family source modules
- there are tracked standalone template roots under `Templates/`
- there is still no single stable public executable API for `TemplateGenerator` published through the package graph

Best starting points:

1. `Sources/iOSAppTemplates/iOSAppTemplates.swift`
2. the relevant `Sources/*Templates/*.swift` lane module
3. `Templates/` for the tracked standalone roots
4. [Portfolio Matrix](./Portfolio-Matrix.md) for the current-vs-target map
