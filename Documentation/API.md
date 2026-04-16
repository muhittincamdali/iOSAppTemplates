# API

Bu sayfa generator-style taslak API degil, repo icindeki bugunku gercek surface'e yonlendirir.

Canonical kaynaklar:

- [API Reference](./API-Reference.md)
- [Architecture API](./ArchitectureAPI.md)

Bugunku public truth:

- root package discovery surface var
- template family source modulleri var
- secili standalone template roots var
- tek ve stabil bir public `TemplateGenerator` executable API'si bugun package icinde yayinlanmis degil

En dogru baslangic:

1. `Sources/iOSAppTemplates/iOSAppTemplates.swift`
2. ilgili `Sources/*Templates/*.swift`
3. `Templates/SocialMediaApp`, `Templates/EcommerceApp`, `Templates/FitnessApp`
