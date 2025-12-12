# Migration Guide: Chauffeur App → AquaTrack

This guide explains the transformation from the chauffeur booking app to the AquaTrack water tracking app.

## Package Name Changes

### Before
```yaml
name: chauffeur_app
```

### After
```yaml
name: aquatrack
```

**Action Required**: Update all imports in your code from `chauffeur_app` to `aquatrack`

## Dependency Changes

### Removed Dependencies
These packages are no longer needed:
- `google_maps_flutter` - Map functionality removed
- `geolocator` - Location services removed
- `geocoding` - Address lookup removed
- `firebase_core` - Firebase removed
- `firebase_auth` - Authentication removed
- `cloud_firestore` - Cloud database removed
- `firebase_messaging` - Cloud messaging removed
- `firebase_storage` - Cloud storage removed
- `dio` - HTTP client removed
- `cached_network_image` - Network images removed
- `image_picker` - Image selection removed
- `url_launcher` - URL launching removed

### New Dependencies
Add these packages:
- `sqflite: ^2.3.3+1` - Local SQLite database
- `path_provider: ^2.1.4` - File system paths
- `path: ^1.9.0` - Path manipulation
- `flutter_local_notifications: ^17.2.3` - Local notifications
- `timezone: ^0.9.4` - Timezone support
- `permission_handler: ^11.3.1` - Permission management
- `fl_chart: ^0.69.0` - Charts and graphs
- `uuid: ^4.5.1` - UUID generation

### Kept Dependencies
These remain the same:
- `flutter_riverpod` - State management
- `shared_preferences` - Key-value storage
- `intl` - Date formatting
- `flutter_animate` - Animations
- `lottie` - Lottie animations
- `iconsax` - Icon pack
- `flutter_svg` - SVG support
- `shimmer` - Shimmer effects

## Architecture Changes

### Old Structure
```
lib/
├── features/
│   ├── auth/
│   ├── booking/
│   ├── history/
│   ├── home/
│   ├── offers/
│   ├── onboarding/
│   ├── profile/
│   ├── ride/
│   ├── splash/
│   └── wallet/
└── core/
```

### New Structure
```
lib/
├── models/          # Data models
├── services/        # Business logic
├── providers/       # State management
├── screens/         # UI screens
├── widgets/         # Reusable widgets
└── core/           # Theme, constants
```

## State Management Migration

### Old: Feature-based Providers
```dart
// Old approach - scattered providers
final authProvider = ...
final bookingProvider = ...
final rideProvider = ...
```

### New: Centralized Provider
```dart
// New approach - single water provider
final waterProvider = StateNotifierProvider<WaterNotifier, WaterState>((ref) {
  return WaterNotifier();
});
```

## Data Storage Migration

### Old: Firebase Firestore
```dart
// Old - Cloud storage
FirebaseFirestore.instance
  .collection('bookings')
  .add(data);
```

### New: Local SQLite
```dart
// New - Local database
DatabaseService.instance
  .createWaterIntake(intake);
```

## Navigation Migration

### Old: Complex Router
```dart
// Old - Generated routes
class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  // ... many more routes
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Complex routing logic
  }
}
```

### New: Simple Routes
```dart
// New - Simple route map
MaterialApp(
  routes: {
    '/': (context) => const SplashScreen(),
    '/main': (context) => const MainNavigationScreen(),
  },
)
```

## Screen Migration Map

| Old Screen | New Screen | Notes |
|------------|------------|-------|
| `splash_screen.dart` | `splash_screen.dart` | Completely redesigned |
| `onboarding_screen.dart` | ❌ Removed | Not needed |
| `sign_in_screen.dart` | ❌ Removed | No authentication |
| `sign_up_screen.dart` | ❌ Removed | No authentication |
| `home_screen.dart` | `home_screen.dart` | Completely redesigned |
| `main_screen.dart` | `main_navigation_screen.dart` | Simplified |
| `history_screen.dart` | `history_screen.dart` | Completely redesigned |
| `profile_screen.dart` | `settings_screen.dart` | Repurposed |
| `booking_*.dart` | ❌ Removed | Not applicable |
| `ride_*.dart` | ❌ Removed | Not applicable |
| `wallet_*.dart` | ❌ Removed | Not applicable |
| `offers_screen.dart` | ❌ Removed | Not applicable |
| N/A | `statistics_screen.dart` | ✨ New |

## Theme Migration

### Color Scheme Changes

```dart
// Old - Deep blue theme
static const Color primary = Color(0xFF1E3A8A);
static const Color secondary = Color(0xFF0EA5E9);

// New - Water/aqua theme
static const Color primary = Color(0xFF0EA5E9);  // Sky blue
static const Color secondary = Color(0xFF06B6D4); // Cyan
static const Color accent = Color(0xFF22D3EE);    // Bright cyan
```

### New Gradients
```dart
// Water-themed gradients
static const LinearGradient waterGradient = LinearGradient(
  colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
```

## Android Configuration Migration

### Package Name
```kotlin
// Old
package com.example.chauffeur_app

// New
package com.example.aquatrack
```

### build.gradle.kts
```kotlin
// Old
namespace = "com.example.chauffeur_app"
applicationId = "com.example.chauffeur_app"
minSdk = flutter.minSdkVersion

// New
namespace = "com.example.aquatrack"
applicationId = "com.example.aquatrack"
minSdk = 21  // Required for notifications
```

### AndroidManifest.xml
```xml
<!-- Old -->
<application android:label="chauffeur_app">

<!-- New -->
<application android:label="AquaTrack">
  
<!-- New permissions -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

## API Changes

### Old: Firebase Authentication
```dart
// Old
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);
```

### New: Local Storage Only
```dart
// New - No authentication needed
// Direct access to features
```

### Old: Cloud Firestore
```dart
// Old
final snapshot = await FirebaseFirestore.instance
  .collection('rides')
  .where('userId', isEqualTo: userId)
  .get();
```

### New: SQLite Queries
```dart
// New
final intakes = await DatabaseService.instance
  .getWaterIntakesByDate(date);
```

## Widget Migration

### Old: Custom Widgets
- `custom_button.dart` - Generic button
- `custom_text_field.dart` - Generic input

### New: Specialized Widgets
- `water_drop_button.dart` - Water amount button
- `circular_water_progress.dart` - Progress indicator
- `animated_water_wave.dart` - Wave animation
- `water_wave_painter.dart` - Custom painter

## Breaking Changes

### 1. No More Authentication
- Remove all auth-related code
- No user accounts or sessions
- All data is local to device

### 2. No More Network Calls
- Remove API endpoints
- Remove Dio/HTTP clients
- All data is stored locally

### 3. No More Firebase
- Remove Firebase initialization
- Remove all Firebase imports
- No cloud sync

### 4. Different Data Models
```dart
// Old
class Ride {
  final String id;
  final String userId;
  final String driverId;
  final Location pickup;
  final Location destination;
}

// New
class WaterIntake {
  final String id;
  final DateTime timestamp;
  final int amountMl;
  final String date;
}
```

## Migration Steps

### Step 1: Clean Old Dependencies
```bash
flutter clean
rm -rf pubspec.lock
```

### Step 2: Update pubspec.yaml
Replace dependencies as listed above

### Step 3: Get New Dependencies
```bash
flutter pub get
```

### Step 4: Update Imports
Find and replace:
- `chauffeur_app` → `aquatrack`

### Step 5: Remove Old Files
Delete these directories:
- `lib/features/auth/`
- `lib/features/booking/`
- `lib/features/ride/`
- `lib/features/wallet/`
- `lib/features/offers/`
- `lib/features/onboarding/`

### Step 6: Update Android Config
- Update package name in MainActivity.kt
- Update namespace in build.gradle.kts
- Update AndroidManifest.xml
- Add notification permissions

### Step 7: Test
```bash
flutter run
```

## Rollback Plan

If you need to revert:

1. **Restore pubspec.yaml**
   ```bash
   git checkout HEAD -- pubspec.yaml
   ```

2. **Restore Android config**
   ```bash
   git checkout HEAD -- android/
   ```

3. **Restore main.dart**
   ```bash
   git checkout HEAD -- lib/main.dart
   ```

4. **Clean and rebuild**
   ```bash
   flutter clean
   flutter pub get
   ```

## Testing Checklist

After migration, test:

- [ ] App launches successfully
- [ ] Splash screen displays
- [ ] Home screen shows progress indicator
- [ ] Can add water intake (all preset amounts)
- [ ] Can add custom amount
- [ ] Can delete water intake (swipe)
- [ ] History calendar displays correctly
- [ ] Statistics charts render
- [ ] Can change daily goal
- [ ] Can enable/disable reminders
- [ ] Notifications work (if enabled)
- [ ] Data persists after app restart
- [ ] Bottom navigation works
- [ ] All animations are smooth

## Common Issues

### Issue: Import errors
**Solution**: Run `flutter pub get` and update all imports

### Issue: Android build fails
**Solution**: Update minSdk to 21 in build.gradle.kts

### Issue: Notifications don't work
**Solution**: Check permissions in AndroidManifest.xml

### Issue: Database errors
**Solution**: Uninstall app and reinstall (clears old data)

### Issue: Theme looks wrong
**Solution**: Verify app_colors.dart has new water theme colors

## Support

For issues during migration:
1. Check this guide
2. Review TRANSFORMATION_SUMMARY.md
3. Check README.md
4. Open an issue on GitHub

---

**Migration Status**: Complete ✅
**Compatibility**: Flutter 3.5.0+
**Platform**: Android (iOS compatible with minor changes)

