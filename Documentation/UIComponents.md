# 🎨 UI Components Guide

Complete UI components documentation for iOS App Templates.

## 📋 Table of Contents

- [Button Components](#button-components)
- [Card Components](#card-components)
- [Input Components](#input-components)
- [Navigation Components](#navigation-components)
- [List Components](#list-components)
- [Modal Components](#modal-components)

## 🔘 Button Components

### **PrimaryButton**
A primary action button with customizable styling.

```swift
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    let isLoading: Bool
    
    init(
        title: String,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    )
}
```

**Example:**
```swift
PrimaryButton(
    title: "Save Changes",
    isLoading: false
) {
    // Handle save action
}
```

### **SecondaryButton**
A secondary action button with outline styling.

```swift
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(
        title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    )
}
```

**Example:**
```swift
SecondaryButton(
    title: "Cancel",
    isEnabled: true
) {
    // Handle cancel action
}
```

### **IconButton**
A button with an icon and optional text.

```swift
struct IconButton: View {
    let icon: String
    let title: String?
    let action: () -> Void
    let isEnabled: Bool
    
    init(
        icon: String,
        title: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    )
}
```

**Example:**
```swift
IconButton(
    icon: "heart.fill",
    title: "Like"
) {
    // Handle like action
}
```

## 🃏 Card Components

### **Card**
A basic card component with customizable content.

```swift
struct Card<Content: View>: View {
    let content: Content
    let style: CardStyle
    let padding: EdgeInsets
    
    init(
        style: CardStyle = .default,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        @ViewBuilder content: () -> Content
    )
}
```

**CardStyle Options:**
- `.default`: Standard card with shadow
- `.elevated`: Card with enhanced shadow
- `.outlined`: Card with border only
- `.flat`: Card without shadow or border

**Example:**
```swift
Card(style: .elevated) {
    VStack(alignment: .leading, spacing: 12) {
        Text("Card Title")
            .font(.headline)
        Text("Card content goes here")
            .font(.body)
    }
}
```

### **ProfileCard**
A card designed for user profiles.

```swift
struct ProfileCard: View {
    let avatar: String
    let name: String
    let subtitle: String?
    let action: (() -> Void)?
    
    init(
        avatar: String,
        name: String,
        subtitle: String? = nil,
        action: (() -> Void)? = nil
    )
}
```

**Example:**
```swift
ProfileCard(
    avatar: "user.avatar",
    name: "John Doe",
    subtitle: "Software Engineer"
) {
    // Handle profile tap
}
```

### **InfoCard**
A card for displaying information with icons.

```swift
struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        description: String,
        action: (() -> Void)? = nil
    )
}
```

**Example:**
```swift
InfoCard(
    icon: "info.circle",
    title: "Information",
    description: "This is an informational card"
) {
    // Handle card tap
}
```

## 📝 Input Components

### **CustomTextField**
A customizable text input field.

```swift
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String?
    let validation: TextFieldValidation
    let isSecure: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        icon: String? = nil,
        validation: TextFieldValidation = .none,
        isSecure: Bool = false
    )
}
```

**TextFieldValidation Options:**
- `.none`: No validation
- `.email`: Email format validation
- `.password`: Password strength validation
- `.phone`: Phone number validation
- `.custom`: Custom validation rule

**Example:**
```swift
CustomTextField(
    text: $email,
    placeholder: "Enter email",
    icon: "envelope",
    validation: .email
)
```

### **CustomToggle**
A customizable toggle switch.

```swift
struct CustomToggle: View {
    @Binding var isOn: Bool
    let title: String
    let subtitle: String?
    let icon: String?
    
    init(
        isOn: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        icon: String? = nil
    )
}
```

**Example:**
```swift
CustomToggle(
    isOn: $notificationsEnabled,
    title: "Enable Notifications",
    subtitle: "Receive push notifications"
)
```

### **CustomSlider**
A customizable slider component.

```swift
struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let title: String?
    
    init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 1.0,
        title: String? = nil
    )
}
```

**Example:**
```swift
CustomSlider(
    value: $brightness,
    range: 0...100,
    step: 1,
    title: "Brightness"
)
```

## 🧭 Navigation Components

### **CustomNavigationBar**
A customizable navigation bar.

```swift
struct CustomNavigationBar: View {
    let title: String
    let leftButton: NavigationButton?
    let rightButton: NavigationButton?
    let backgroundColor: Color
    
    init(
        title: String,
        leftButton: NavigationButton? = nil,
        rightButton: NavigationButton? = nil,
        backgroundColor: Color = .systemBackground
    )
}
```

**NavigationButton:**
```swift
struct NavigationButton {
    let icon: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(
        icon: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    )
}
```

**Example:**
```swift
CustomNavigationBar(
    title: "Profile",
    leftButton: NavigationButton(
        icon: "chevron.left"
    ) {
        // Handle back action
    },
    rightButton: NavigationButton(
        icon: "ellipsis"
    ) {
        // Handle menu action
    }
)
```

### **CustomTabBar**
A customizable tab bar.

```swift
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    init(
        selectedTab: Binding<Int>,
        tabs: [TabItem]
    )
}
```

**TabItem:**
```swift
struct TabItem {
    let icon: String
    let title: String
    let badge: String?
    
    init(
        icon: String,
        title: String,
        badge: String? = nil
    )
}
```

**Example:**
```swift
CustomTabBar(
    selectedTab: $selectedTab,
    tabs: [
        TabItem(icon: "house", title: "Home"),
        TabItem(icon: "heart", title: "Favorites", badge: "3"),
        TabItem(icon: "person", title: "Profile")
    ]
)
```

## 📋 List Components

### **CustomList**
A customizable list component.

```swift
struct CustomList<Content: View>: View {
    let content: Content
    let style: ListStyle
    let spacing: CGFloat
    
    init(
        style: ListStyle = .default,
        spacing: CGFloat = 8,
        @ViewBuilder content: () -> Content
    )
}
```

**ListStyle Options:**
- `.default`: Standard list style
- `.grouped`: Grouped list style
- `.insetGrouped`: Inset grouped list style
- `.plain`: Plain list style

**Example:**
```swift
CustomList(style: .grouped, spacing: 12) {
    ForEach(users) { user in
        UserRowView(user: user)
    }
}
```

### **UserRowView**
A row view for displaying user information.

```swift
struct UserRowView: View {
    let user: User
    let showAvatar: Bool
    let showSubtitle: Bool
    let action: (() -> Void)?
    
    init(
        user: User,
        showAvatar: Bool = true,
        showSubtitle: Bool = true,
        action: (() -> Void)? = nil
    )
}
```

**Example:**
```swift
UserRowView(
    user: user,
    showAvatar: true,
    showSubtitle: true
) {
    // Handle row tap
}
```

### **SettingsRowView**
A row view for settings screens.

```swift
struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String?
    let accessory: RowAccessory
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        accessory: RowAccessory = .none,
        action: (() -> Void)? = nil
    )
}
```

**RowAccessory Options:**
- `.none`: No accessory
- `.chevron`: Chevron arrow
- `.switch`: Toggle switch
- `.badge(String)`: Badge with text
- `.custom(AnyView)`: Custom accessory

**Example:**
```swift
SettingsRowView(
    icon: "bell",
    title: "Notifications",
    subtitle: "Manage notification settings",
    accessory: .chevron
) {
    // Handle row tap
}
```

## 🪟 Modal Components

### **CustomAlert**
A customizable alert dialog.

```swift
struct CustomAlert: View {
    let title: String
    let message: String?
    let primaryButton: AlertButton
    let secondaryButton: AlertButton?
    let isPresented: Binding<Bool>
    
    init(
        title: String,
        message: String? = nil,
        primaryButton: AlertButton,
        secondaryButton: AlertButton? = nil,
        isPresented: Binding<Bool>
    )
}
```

**AlertButton:**
```swift
struct AlertButton {
    let title: String
    let style: AlertButtonStyle
    let action: () -> Void
    
    init(
        title: String,
        style: AlertButtonStyle = .default,
        action: @escaping () -> Void
    )
}
```

**AlertButtonStyle Options:**
- `.default`: Standard button style
- `.destructive`: Red/danger button style
- `.cancel`: Cancel button style

**Example:**
```swift
CustomAlert(
    title: "Delete Item",
    message: "Are you sure you want to delete this item?",
    primaryButton: AlertButton(
        title: "Delete",
        style: .destructive
    ) {
        // Handle delete
    },
    secondaryButton: AlertButton(
        title: "Cancel",
        style: .cancel
    ) {
        // Handle cancel
    },
    isPresented: $showAlert
)
```

### **CustomSheet**
A customizable sheet presentation.

```swift
struct CustomSheet<Content: View>: View {
    let content: Content
    let isPresented: Binding<Bool>
    let style: SheetStyle
    
    init(
        isPresented: Binding<Bool>,
        style: SheetStyle = .default,
        @ViewBuilder content: () -> Content
    )
}
```

**SheetStyle Options:**
- `.default`: Standard sheet style
- `.large`: Large sheet style
- `.medium`: Medium sheet style
- `.custom`: Custom sheet style

**Example:**
```swift
CustomSheet(
    isPresented: $showSheet,
    style: .large
) {
    VStack {
        Text("Sheet Content")
        Button("Dismiss") {
            showSheet = false
        }
    }
}
```

### **CustomActionSheet**
A customizable action sheet.

```swift
struct CustomActionSheet: View {
    let title: String?
    let message: String?
    let buttons: [ActionButton]
    let isPresented: Binding<Bool>
    
    init(
        title: String? = nil,
        message: String? = nil,
        buttons: [ActionButton],
        isPresented: Binding<Bool>
    )
}
```

**ActionButton:**
```swift
struct ActionButton {
    let title: String
    let style: ActionButtonStyle
    let action: () -> Void
    
    init(
        title: String,
        style: ActionButtonStyle = .default,
        action: @escaping () -> Void
    )
}
```

**ActionButtonStyle Options:**
- `.default`: Standard button style
- `.destructive`: Red/danger button style
- `.cancel`: Cancel button style

**Example:**
```swift
CustomActionSheet(
    title: "Choose Option",
    message: "Select an action to perform",
    buttons: [
        ActionButton(title: "Edit") {
            // Handle edit
        },
        ActionButton(title: "Delete", style: .destructive) {
            // Handle delete
        },
        ActionButton(title: "Cancel", style: .cancel) {
            // Handle cancel
        }
    ],
    isPresented: $showActionSheet
)
```

## 📚 Next Steps

1. **Read [Getting Started](GettingStarted.md)** for quick setup
2. **Check [Architecture Guide](Architecture.md)** for architecture patterns
3. **Explore [Template Guide](TemplateGuide.md)** for template usage
4. **See [API Reference](API.md)** for complete documentation

## 🤝 Support

- **Documentation**: [Complete Documentation](Documentation/)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/iOSAppTemplates/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/iOSAppTemplates/discussions)

---

**Happy building with iOS App Templates! 🎨** 