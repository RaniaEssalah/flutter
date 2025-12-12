# AquaTrack - Water Intake Tracker

A beautiful and intuitive Flutter application to help you stay hydrated by tracking your daily water intake.

## Features

### Core Features
- **Daily Water Tracking**: Log your water intake with preset amounts (250ml, 500ml, 750ml, 1L) or custom amounts
- **Visual Progress Indicator**: Beautiful circular progress bar with animated water waves showing your daily progress
- **Daily Goal Setting**: Set and adjust your daily water intake goal (default 2.5 liters)
- **History View**: Calendar view showing past days' water intake with color-coded progress indicators
- **Smart Reminders**: Customizable notification reminders to drink water at set intervals
- **Statistics & Charts**: Weekly and monthly charts showing your drinking patterns and trends
- **Achievement System**: Unlock badges and milestones for consistent tracking

### Design & UI
- Clean, minimal design with blue/aqua color scheme
- Animated water waves and ripple effects
- Smooth animations for water level changes
- Easy-to-tap buttons for quick logging
- Interactive charts for visualizing drinking patterns
- Swipe-to-delete functionality for logged entries

### Technical Features
- Local storage using SQLite for water intake data
- SharedPreferences for user settings and achievements
- Local notifications with customizable intervals
- Beautiful charts using fl_chart library
- State management with Riverpod
- Clean architecture with separation of concerns

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   └── widgets/
│       ├── custom_button.dart
│       └── custom_text_field.dart
├── models/
│   ├── achievement.dart
│   ├── daily_goal.dart
│   ├── reminder_settings.dart
│   └── water_intake.dart
├── providers/
│   └── water_provider.dart
├── screens/
│   ├── history_screen.dart
│   ├── home_screen.dart
│   ├── main_navigation_screen.dart
│   ├── settings_screen.dart
│   ├── splash_screen.dart
│   └── statistics_screen.dart
├── services/
│   ├── database_service.dart
│   ├── notification_service.dart
│   └── preferences_service.dart
├── widgets/
│   ├── animated_water_wave.dart
│   ├── circular_water_progress.dart
│   ├── water_drop_button.dart
│   └── water_wave_painter.dart
└── main.dart
```

## Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1          # State management
  sqflite: ^2.3.3+1                 # Local database
  shared_preferences: ^2.3.2        # Key-value storage
  flutter_local_notifications: ^17.2.3  # Push notifications
  fl_chart: ^0.69.0                 # Charts and graphs
  intl: ^0.19.0                     # Internationalization
  uuid: ^4.5.1                      # Unique ID generation
  flutter_animate: ^4.5.0           # Animations
  lottie: ^3.1.2                    # Lottie animations
  iconsax: ^0.0.8                   # Icon pack
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.5.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd aquatrack
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

### Home Screen
- View your daily progress with an animated circular water indicator
- Tap preset amount buttons (250ml, 500ml, 750ml, 1L) to quickly log water intake
- Use the "Custom" button to enter any amount
- View today's log with timestamps
- Swipe left on any entry to delete it

### History Screen
- View a calendar showing your water intake history
- Color-coded days indicate progress levels:
  - Grey: No data
  - Light blue: < 50% of goal
  - Medium blue: 50-75% of goal
  - Blue: 75-100% of goal
  - Dark blue: 100%+ of goal
- See monthly statistics including days tracked, goals met, and daily average

### Statistics Screen
- Toggle between weekly and monthly views
- Interactive bar charts showing daily intake
- Overview statistics including:
  - Total intake
  - Daily average
  - Days met goal
  - Best day
- View unlocked achievements

### Settings Screen
- Adjust daily water goal
- Enable/disable reminder notifications
- Set reminder interval (30 min, 1 hour, 2 hours, 3 hours)
- Configure active hours for reminders
- View app information

## Achievements

Unlock achievements by maintaining healthy hydration habits:
- 💧 **First Drop**: Log your first water intake
- 🔥 **3-Day Streak**: Meet your goal for 3 days in a row
- ⭐ **Week Warrior**: Meet your goal for 7 days in a row
- 🏆 **Two Week Champion**: Meet your goal for 14 days in a row
- 👑 **Monthly Master**: Meet your goal for 30 days in a row
- 💎 **Perfect Week**: Exceed your goal every day for a week
- 🦸 **Hydration Hero**: Drink 5 liters in a single day
- 🌅 **Early Bird**: Log water before 8 AM for 5 days
- 🌙 **Night Owl**: Complete your goal after 10 PM

## Customization

### Changing Daily Goal
1. Go to Settings
2. Tap on "Daily Water Goal"
3. Enter your desired goal in liters
4. Recommended: 2-3 liters per day

### Setting Up Reminders
1. Go to Settings
2. Enable "Reminders"
3. Grant notification permissions when prompted
4. Select your preferred reminder interval
5. Set active hours (coming soon)

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Icons from Iconsax
- Charts powered by fl_chart
- Animations with Flutter Animate
- State management with Riverpod

## Support

For support, please open an issue in the repository or contact the development team.

---

**Stay Hydrated, Stay Healthy! 💧**
