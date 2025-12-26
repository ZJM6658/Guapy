# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Clipy** is a macOS clipboard extension application built with Swift and Cocoa. It provides clipboard history, snippets management, and advanced clipboard features.

**Tech Stack:**
- Language: Swift 5.3
- Platform: macOS 10.10+
- IDE: Xcode 12.2 (use `.xcworkspace`, not `.xcodeproj`)
- Build System: Xcode + CocoaPods

## Build and Development Commands

```bash
# Initial setup - install Ruby and CocoaPods dependencies
bundle install --path=vendor/bundle && bundle exec pod install

# Open the project (must use .xcworkspace)
open Clipy.xcworkspace

# Run tests
fastlane test

# Lint code
bundle exec pod exec swiftlint

# Regenerate localized strings
bundle exec pod exec BartyCrouch
```

## Architecture

### Dependency Injection Pattern

The app uses a custom **Environment pattern** for dependency injection. All services are accessed through `AppEnvironment.current`:

```swift
// Access services
AppEnvironment.current.clipService.startMonitoring()
AppEnvironment.current.hotKeyService.setupDefaultHotKeys()
AppEnvironment.current.menuManager.setup()
```

The `Environment` struct (in `Sources/Environments/Environment.swift`) holds all service dependencies, and `AppEnvironment` provides a stack-based environment system useful for testing.

### Service Layer

Business logic is encapsulated in services (all in `Sources/Services/`):

| Service | Purpose |
|---------|---------|
| `ClipService` | Monitors clipboard changes and manages clip history |
| `HotKeyService` | Handles global keyboard shortcuts |
| `DataCleanService` | Automatically cleans up old clipboard items |
| `PasteService` | Handles clipboard paste operations |
| `ExcludeAppService` | Manages app exclusion rules |
| `AccessibilityService` | Manages macOS accessibility permissions |
| `MenuManager` | Manages status bar and context menus |

### Data Layer

- **Persistence**: RealmSwift for local database
- **Caching**: PINCache for performance
- **Models**: `CPYClip`, `CPYSnippet`, `CPYFolder` (in `Sources/Models/`)

### Reactive Programming

The app heavily uses **RxSwift** for asynchronous operations and data binding. When working with UI events or service interactions, prefer using RxSwift patterns:

```swift
defaults.rx.observe(Bool.self, key)
    .compactMap { $0 }
    .subscribe(onNext: { [weak self] value in
        // Handle change
    })
    .disposed(by: disposeBag)
```

### Application Lifecycle

The app initializes in `AppDelegate.applicationDidFinishLaunching`:
1. Sets up environment from storage
2. Registers UserDefaults
3. Initializes SDKs
4. Checks accessibility permissions
5. Binds RxSwift observers
6. Starts services (clip monitoring, data clean, etc.)
7. Sets up menu manager

## Code Conventions

### Naming

- **Classes**: Prefix `CPY` (e.g., `CPYClip`, `CPYPreferencesWindowController`)
- **Services**: Suffix `Service` (e.g., `ClipService`, `HotKeyService`)
- **Managers**: Suffix `Manager` (e.g., `MenuManager`)

### File Organization

```
Clipy/Sources/
├── AppDelegate.swift           # App entry point
├── Constants.swift             # Centralized constants
├── Environments/               # DI container (Environment, AppEnvironment)
├── Extensions/                 # Swift extensions
├── Managers/                   # UI managers (MenuManager)
├── Models/                      # Realm data models
├── Services/                   # Business logic services
├── Preferences/               # Settings UI
├── Snippets/                   # Snippet management
├── Utility/                    # Helper utilities
└── Views/                      # Custom UI components
```

### Generated Code

The `Generated/` directory contains auto-generated code via **SwiftGen**:
- Localization strings (`L10n`)
- Asset catalogs
- Color definitions

Do not edit these files manually. Run `bundle exec pod exec swiftgen` to regenerate.

## Code Quality

- **SwiftLint**: Configured with 300 character line length (see `.swiftlint.yml`)
- **Testing**: Uses Quick/Nimble for BDD-style tests
- **CI**: GitHub Actions workflow in `.github/workflows/`

## Localization

- Localized strings are in `Resources/*.lproj/` directories
- Use `BartyCrouch` to manage translations
- Access strings via generated `L10n` enum (e.g., `L10n.clearHistory`)

## Key Dependencies

| Dependency | Purpose |
|------------|---------|
| RealmSwift | Database |
| RxSwift/RxCocoa | Reactive programming |
| Magnet | Global hotkeys |
| Sparkle | Auto-updates |
| PINCache | Performance caching |
| KeyHolder | Menu bar shortcuts |
| LoginServiceKit | Login item management |
| LetsMove | Move to Applications folder |

## Important Notes

- **Always use `.xcworkspace`** - CocoaPods integration requires the workspace, not the project
- **Accessibility permissions** are required for clipboard monitoring - the app prompts users on first launch
- **Realm migration** occurs in `AppDelegate.awakeFromNib()`
- **Beta features** can be toggled via UserDefaults (see `Constants.Beta`)
