# ZooEye UI - Folder Structure & Architecture Guide

## 📁 Project Folder Structure

```
lib/
├── main.dart                 # App entry point with Theme & RTL configuration
├── theme/
│   └── app_theme.dart        # Centralized theme with colors, typography, and RTL support
├── screens/
│   ├── index.dart            # Barrel export for all screens
│   ├── home_screen.dart      # Main screen with BottomNavigationBar (Explore + History tabs)
│   ├── details_screen.dart   # Animal detail view with image, name, info, bookmark button
│   └── history_screen.dart   # Saved animals ListView
├── viewmodels/
│   ├── index.dart            # Barrel export for all cubits
│   ├── explore_screen_cubit.dart   # ViewModel for Explore tab (TODO: ML Kit + Wikipedia integration)
│   └── history_screen_cubit.dart   # ViewModel for History tab (TODO: Local DB integration)
├── models/
│   ├── index.dart            # Barrel export for all models
│   ├── animal.dart           # Animal data model with copyWith support
│   └── animal_history.dart   # AnimalHistory extends Animal with savedAt timestamp
├── widgets/
│   └── [Custom reusable widgets can be placed here]
└── utils/
    └── [Utility functions and helpers]
```

## 🏗️ Architecture: MVVM Pattern

### Core Principles

1. **Separation of Concerns**: UI (View) is completely decoupled from business logic (ViewModel)
2. **Micro-Widgets**: No widget exceeds 50-70 lines. Smaller, focused, reusable widgets
3. **Cubit for State Management**: BLoC Cubit pattern for predictable state management
4. **Responsiveness**: All layouts use MediaQuery, Flexible, Expanded, AspectRatio (no hardcoded sizes)

### Data Flow

```
User Interaction (UI) 
    ↓
Cubit Methods (ViewModel) 
    ↓
Business Logic (API calls, DB queries - TODO)
    ↓
State Emission
    ↓
Rebuild UI with new state
```

### Layer Breakdown

#### 🎨 **View Layer** (`screens/`)
- **HomeScreen**: Entry point with BottomNavigationBar
  - `_ExploreTabContent`: Explore tab with camera placeholder
  - `_HistoryTabContent`: History tab placeholder
  - `_CameraPlaceholder`: Responsive camera viewfinder area
  - `_ActionButtons`: Take Photo and Choose from Gallery buttons
  - `_WelcomeHeader`: Welcome text
  - `_BottomNavigation`: Bottom navigation bar

- **DetailsScreen**: Animal details view
  - `_AnimalImage`: Responsive image container
  - `_AnimalNameHeader`: Animal name display
  - `_AnimalInfoCard`: Wikipedia extract card
  - `_BookmarkButton`: AppBar bookmark toggle
  - `_SaveToHistoryButton`: Save to history action

- **HistoryScreen**: Saved animals list
  - `HistoryListView`: ListView builder for saved animals
  - `_AnimalHistoryCard`: Individual animal card
  - `_AnimalThumbnail`: Image thumbnail
  - `_AnimalCardInfo`: Name and save date
  - `_AnimalCardActions`: Delete with confirmation
  - `_EmptyHistoryWidget`: Empty state placeholder

#### 🧠 **ViewModel Layer** (`viewmodels/`)

**ExploreScreenCubit**
```dart
// States
- ExploreScreenInitial
- ExploreScreenLoading
- ExploreScreenAnimalIdentified(Animal animal)
- ExploreScreenError(String message)

// Methods (TODO: Implement these)
- takePhoto()              // Capture photo + ML Kit detection
- chooseFromGallery()      // Gallery picker + ML Kit detection
- onAnimalIdentified()     // Fetch Wikipedia data
- reset()                  // Return to initial state
```

**HistoryScreenCubit**
```dart
// States
- HistoryScreenInitial
- HistoryScreenLoading
- HistoryScreenLoaded(List<AnimalHistory> animals)
- HistoryScreenEmpty
- HistoryScreenError(String message)

// Methods (TODO: Implement these)
- fetchSavedAnimals()      // Query local database
- deleteAnimal(id)         // Delete from database
- unbookmarkAnimal(id)     // Remove bookmark
```

#### 📊 **Model Layer** (`models/`)

**Animal** (Base model)
```dart
Animal {
  - id: String
  - name: String (e.g., "African Lion")
  - imageUrl: String?
  - description: String? (Wikipedia excerpt)
  - identifiedAt: DateTime?
  - isBookmarked: bool
  - copyWith() // For immutable updates
}
```

**AnimalHistory** (Extends Animal)
```dart
AnimalHistory extends Animal {
  - savedAt: String (timestamp when saved)
}
```

#### 🎨 **Theme Layer** (`theme/`)

**AppTheme Configuration**
- **Color Palette**:
  - Primary Green: `#2D7A3E` (Nature-inspired)
  - Secondary Green: `#4A9D6F`
  - Light Grey: `#F5F5F5` (Backgrounds)
  - Dark Grey: `#616161` (Text)
  
- **Typography**: Material 3 text theme with Arabic RTL optimization
  - DisplayLarge/Medium/Small for headlines
  - TitleLarge/Medium/Small for section headers
  - BodyLarge/Medium/Small for content
  - LabelLarge/Medium/Small for buttons
  
- **Components**: Themed buttons, cards, AppBar, BottomNavBar

## 🔄 State Management Flow

### Explore Screen Flow
```
HomeScreen (UI) 
  → ExploreScreenCubit.takePhoto() / chooseFromGallery()
  → Emit ExploreScreenLoading
  → [TODO] ML Kit Detection
  → [TODO] Wikipedia API Fetch
  → Emit ExploreScreenAnimalIdentified(animal)
  → Navigate to DetailsScreen(animal)
```

### History Screen Flow
```
HistoryScreen (UI)
  → Init: HistoryScreenCubit.fetchSavedAnimals()
  → Emit HistoryScreenLoading
  → [TODO] Query local database (Hive/SQLite)
  → Emit HistoryScreenLoaded(animals) or HistoryScreenEmpty
  → Display ListView of AnimalHistory items
```

## 📐 Responsive Design Principles Used

1. **No Fixed Heights/Widths**: All sizing uses `MediaQuery`, `Flexible`, `Expanded`, `AspectRatio`
2. **Proportional Sizing**: Image containers use `height: MediaQuery.of(context).size.height * 0.35`
3. **Flexible Widgets**: Action buttons and cards expand to fill available space
4. **RTL Support**: All screens use `Directionality(textDirection: TextDirection.rtl)`

## 🌍 Localization & RTL

- **Default Locale**: Arabic (ar_SA)
- **Fallback Locale**: English (en_US)
- **Text Direction**: RTL (Right-to-Left) for Arabic
- **All UI Text**: In Arabic with proper grammar and context

### Sample Arabic Text:
- "اكتشف الحيوانات" = "Discover Animals"
- "التقط صورة" = "Take Photo"
- "السجل" = "History"
- "معلومات عن الحيوان" = "Animal Information"

## 🔮 TODO: Integration Points

### 1. ML Kit Integration (ExploreScreenCubit)
```dart
// Replace in takePhoto() & chooseFromGallery()
- Use google_ml_kit package
- Initialize PoseDetector or other ML models
- Detect animal from image
- Return Animal name
```

### 2. Wikipedia API Integration (ExploreScreenCubit)
```dart
// Replace in onAnimalIdentified()
- Call Wikipedia API with animal name
- Parse description/extract
- Populate Animal.description field
```

### 3. Local Database Integration (HistoryScreenCubit)
```dart
// Use Hive, SQLite, or Drift for persistence
- fetchSavedAnimals(): Query database
- saveAnimal(): Insert into database
- deleteAnimal(): Remove from database
- unbookmarkAnimal(): Update isBookmarked flag
```

### 4. Navigation Integration (main.dart)
```dart
// Connect DetailsScreen navigation
- From HomeScreen (after animal identified)
- Pass Animal object to DetailsScreen
- Implement pop behavior
```

### 5. Cubit Listeners in Views (home_screen.dart, history_screen.dart)
```dart
// Add BlocListener and BlocBuilder wrappers
BlocBuilder<ExploreScreenCubit, ExploreScreenState>(
  builder: (context, state) {
    if (state is ExploreScreenAnimalIdentified) {
      // Navigate to DetailsScreen(state.animal)
    }
    // ... handle other states
  },
)
```

## 🎯 Key Features Implemented

✅ **MVVM Architecture**: Complete separation of concerns with Cubit
✅ **Micro-Widgets**: All widgets 50-70 lines max, highly reusable
✅ **Responsive UI**: No hardcoded sizes, fully responsive design
✅ **Nature Theme**: Green color palette with soft shadows and rounded corners
✅ **Arabic/RTL Support**: All text in Arabic, proper RTL directionality
✅ **Three Main Screens**:
  - HomeScreen with BottomNavigationBar
  - DetailsScreen with animal info
  - HistoryScreen with saved animals ListView
✅ **Placeholder States**: Empty history, loading, error states designed
✅ **UI-Only**: No actual ML Kit, API, or DB logic implemented (all marked TODO)

## 🚀 Getting Started

### Prerequisites
```bash
flutter pub get
```

### Dependencies Added
```yaml
flutter_bloc: ^8.1.4
bloc: ^8.1.2
```

### Run the App
```bash
flutter run
```

The app will launch with:
- Explore tab showing camera placeholder and action buttons
- History tab showing empty state
- RTL Arabic UI with nature-inspired green theme
- Fully responsive layouts on mobile and tablets

## 📝 Notes for Developers

1. **Cubit Implementation**: When integrating business logic, follow the TODO comments in cubits
2. **Navigation**: Use `Navigator.push()` for DetailsScreen after animal identification
3. **BlocListener**: Wrap screens with `BlocListener` to react to cubit state changes
4. **Database**: Choose one: Hive (simpler), SQLite (more control), or Drift (type-safe)
5. **Image Caching**: Consider using `cached_network_image` package for Wikipedia images
6. **Error Handling**: Implement proper error dialogs in BlocListener catch blocks

---

**Built with ❤️ for ZooEye - Smart Animal Identification**
