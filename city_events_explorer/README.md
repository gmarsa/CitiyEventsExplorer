# City Events Explorer

A Flutter application for exploring city events with search, filtering, and favourite functionality.

## 🚀 Features

- ✅ **Browse Events**: Load and display events from local JSON data
- ✅ **Search & Filter**: Search by text and filter by category and date range
- ✅ **Favourites**: Save favourite events locally with persistence
- ✅ **Event Details**: Detailed view with map preview and event information
- ✅ **Modern UI**: Material Design 3 with responsive layout
- ✅ **State Management**: BLoC pattern for predictable state management
- ✅ **Testing**: Unit tests and widget tests with good coverage

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
├── lib/
│   ├── main.dart                          # App entry point
│   └── src/
│       ├── data/                          # Data Layer
│       │   ├── datasources/              # Local data sources
│       │   └── repositories/             # Repository implementations
│       ├── domain/                        # Domain Layer
│       │   ├── models/                    # Data models/entities
│       │   └── repositories/             # Repository interfaces
│       └── presentation/                  # Presentation Layer
│           ├── blocs/                     # BLoC state management
│           ├── pages/                     # Screen widgets
│           └── widgets/                   # Reusable UI components
├── assets/
│   └── data/
│       └── events.json                    # Local event data
├── test/                                  # Tests
│   ├── unit/                             # Unit tests
│   └── widget/                           # Widget tests
└── docs/
    └── ADR-001.md                        # Architecture decisions
```

## 🛠️ Technology Stack

- **Framework**: Flutter 3.32.4
- **Language**: Dart 3.8+
- **State Management**: flutter_bloc
- **Local Storage**: shared_preferences
- **JSON Serialization**: json_annotation + build_runner
- **HTTP Caching**: cached_network_image
- **Maps**: flutter_map (OpenStreetMap)
- **Testing**: flutter_test, mockito

### Home Screen
- Event list with search and filters
- Pull-to-refresh functionality
- Category filter dropdown
- Floating action button to access favourites

### Event Details
- Full event information with expandable app bar
- Map preview with location marker
- Add to favourites functionality
- Share and directions buttons

### Favourites
- Persistent favourite events list
- Empty state with guidance to browse events
- Same event cards as main list

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Device or emulator for testing

### Installation

1. **Clone the repository**
   
   git clone 
   cd city_events_explorer
   

2. **Install dependencies**
   
   flutter pub get
   

3. **Generate code (JSON serialization)**
   flutter packages pub run build_runner build
   

4. **Run the application**
   flutter run


### Running Tests

# Run all tests
flutter test

# Run specific test file
flutter test test/unit/events_repository_test.dart

# Run tests with coverage
flutter test --coverage


### Code Generation

When you modify model classes, regenerate the serialization code:


# Clean previous generated files
flutter packages pub run build_runner clean

# Generate new code
flutter packages pub run build_runner build --delete-conflicting-outputs


## 🏛️ Architecture Decisions

See [docs/ADR-001.md](docs/ADR-001.md) for detailed architectural decisions and rationale.

### Key Architectural Choices

- **Clean Architecture**: Separation of concerns with clear layer boundaries
- **BLoC Pattern**: Predictable state management with clear separation of events and states
- **Manual Dependency Injection**: Simple, explicit dependency management
- **Repository Pattern**: Abstraction layer for data access
- **Local-First**: JSON file storage with SharedPreferences for user data

## 📁 Project Structure

```
city_events_explorer/
├── android/                    # Android platform files
├── ios/                        # iOS platform files
├── lib/
│   ├── main.dart              # Application entry point
│   └── src/
│       ├── data/              # Data layer implementation
│       │   ├── datasources/
│       │   │   ├── events_local_datasource.dart
│       │   │   └── favourites_local_datasource.dart
│       │   └── repositories/
│       │       ├── events_repository_impl.dart
│       │       └── favourites_repository_impl.dart
│       ├── domain/            # Business logic and entities
│       │   ├── models/
│       │   │   ├── event.dart
│       │   │   └── location.dart
│       │   └── repositories/
│       │       ├── events_repository.dart
│       │       └── favourites_repository.dart
│       └── presentation/      # UI and state management
│           ├── blocs/
│           │   ├── events/
│           │   └── favourites/
│           ├── pages/
│           │   ├── home_page.dart
│           │   ├── event_detail_page.dart
│           │   └── favourites_page.dart
│           └── widgets/
│               ├── event_card.dart
│               ├── events_list.dart
│               ├── search_and_filters.dart
│               └── event_map_preview.dart
├── assets/
│   └── data/
│       └── events.json        # Event data source
├── test/
│   ├── unit/                  # Unit tests
│   └── widget/                # Widget tests
├── docs/
│   └── ADR-001.md            # Architecture Decision Record
├── analysis_options.yaml     # Dart/Flutter linting rules
├── pubspec.yaml              # Dependencies and project configuration
└── README.md                 # This file
```

## 🧪 Testing Strategy

### Unit Tests
- **Repository Tests**: Data layer logic and error handling
- **BLoC Tests**: State management and business logic
- **Model Tests**: JSON serialization and deserialization

### Widget Tests
- **Component Tests**: Individual widget rendering and interaction
- **Integration Tests**: Widget communication with BLoCs

### Coverage Areas
- Repository implementations with various scenarios
- BLoC state transitions and event handling
- Widget rendering and user interactions
- Error states and edge cases

## 📦 Dependencies

### Main Dependencies
- `flutter_bloc`: State management
- `equatable`: Value equality for BLoC states
- `shared_preferences`: Local storage for favourites
- `cached_network_image`: Image caching and loading
- `flutter_map`: Map display with OpenStreetMap
- `json_annotation`: JSON serialization annotations
- `intl`: Date formatting and internationalization

### Development Dependencies
- `mockito`: Mocking for unit tests
- `build_runner`: Code generation
- `json_serializable`: JSON serialization code generation
- `flutter_lints`: Linting rules

## 🔧 Configuration

### Linting
The project uses strict linting rules defined in `analysis_options.yaml` to ensure code quality and consistency.

### JSON Data
Event data is stored in `assets/data/events.json`. To add new events, modify this file and the changes will be reflected in the app.

## 🚦 Development Workflow

1. **Make changes** to models, repositories, or UI
2. **Run code generation** if models were modified
3. **Run tests** to ensure functionality
4. **Check linting** with `flutter analyze`
5. **Test on device/emulator**

## 📋 Features Checklist

- [x] FR-1: Load event data from local JSON file
- [x] FR-2: Display scrollable list with pull-to-refresh
- [x] FR-3: Event detail screen with map and favourites
- [x] FR-4: Persistent favourite events storage
- [x] Search functionality across multiple fields
- [x] Category filtering with dropdown
- [x] Date range filtering
- [x] Modern Material Design 3 UI
- [x] BLoC state management
- [x] Clean architecture implementation
- [x] Unit and widget tests
- [x] Code generation for JSON serialization
- [x] Comprehensive documentation

## 🔮 Future Enhancements

- [ ] **API Integration**: Replace local JSON with REST API
- [ ] **Push Notifications**: Event reminders and updates
- [ ] **Social Features**: Event sharing and reviews
- [ ] **Advanced Filtering**: Price ranges, distance-based filtering
- [ ] **Offline Sync**: Full offline support with background sync
- [ ] **Accessibility**: Enhanced screen reader support
- [ ] **Animations**: Smooth transitions and micro-interactions
- [ ] **Localization**: Multi-language support

## 📄 License

This project is created for evaluation purposes.


**Created using Flutter**