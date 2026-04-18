# Examples Hub

Bu klasor henuz full complete-app gallery degil. Bugunku rol:

- source-level reference
- lightweight onboarding example
- richer social example surface

## Canonical Example Router

| Surface | Type | Use it for |
| --- | --- | --- |
| [BasicExample.swift](./BasicExample.swift) | single-file reference | package API'yi hizli gormek |
| [BasicExample/BasicExample.swift](./BasicExample/BasicExample.swift) | small example shell | minimal structure incelemek |
| [QuickStartExample/QuickStartApp.swift](./QuickStartExample/QuickStartApp.swift) | onboarding entry | en hizli source-level baslangic |
| [SocialMediaExample](./SocialMediaExample/) | richer category example | social lane icin daha urun benzeri akis gormek |

## Important Truth

- Bu klasor altindaki her sey ayrik runnable Xcode project degil.
- En guvenilir standalone package-entry path bugun `Templates/` altindaki standalone roots.
- En guvenilir repo validation path bugun root `swift build` ve `swift test`.

## If You Want To Run Something

### Package truth

```bash
swift build
swift test
```

### Standalone roots inceleme

```bash
open ../Templates/SocialMediaApp/Package.swift
open ../Templates/EcommerceApp/Package.swift
open ../Templates/FitnessApp/Package.swift
```

### Generator path

```bash
swift ../Scripts/TemplateGenerator.swift --interactive
```

## Related Docs

- [../Documentation/Guides/QuickStart.md](../Documentation/Guides/QuickStart.md)
- [../Documentation/Portfolio-Matrix.md](../Documentation/Portfolio-Matrix.md)
- [../Documentation/Template-Showcase.md](../Documentation/Template-Showcase.md)
- [../Documentation/TemplateGuide.md](../Documentation/TemplateGuide.md)
- [../Documentation/Proof-Matrix.md](../Documentation/Proof-Matrix.md)
- [../Documentation/App-Proofs/README.md](../Documentation/App-Proofs/README.md)
- [../Documentation/Complete-App-Standard.md](../Documentation/Complete-App-Standard.md)
- [../Documentation/Wave-1-Implementation-Plan.md](../Documentation/Wave-1-Implementation-Plan.md)
