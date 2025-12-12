# AquaTrack - Project Overview

## 🌊 What is AquaTrack?

AquaTrack is a beautiful, feature-rich Flutter application designed to help users track their daily water intake and maintain healthy hydration habits. With an intuitive interface, animated water effects, and comprehensive tracking features, AquaTrack makes staying hydrated fun and engaging.

## ✨ Key Features

### 1. **Daily Water Tracking**
- Quick-add buttons for common amounts (250ml, 500ml, 750ml, 1L)
- Custom amount entry for any volume
- Real-time progress tracking
- Visual feedback with animated water waves

### 2. **Beautiful Visualizations**
- Circular progress indicator with animated water fill
- Color-coded calendar showing hydration history
- Interactive bar charts for weekly/monthly trends
- Smooth animations throughout the app

### 3. **Smart Reminders**
- Customizable notification intervals (30min to 3 hours)
- Configurable active hours
- Multiple reminder messages for variety
- Permission handling for Android 13+

### 4. **Achievement System**
- 9 unique achievements to unlock
- Streak tracking (3-day, 7-day, 14-day, 30-day)
- Special achievements (Early Bird, Night Owl, Hydration Hero)
- Visual progress in statistics screen

### 5. **Comprehensive Statistics**
- Weekly and monthly views
- Daily average calculations
- Goal achievement tracking
- Best day records
- Interactive charts with tooltips

### 6. **Flexible Settings**
- Adjustable daily goals (0.1L to 10L)
- Reminder configuration
- Interval selection
- About section with app info

## 🎨 Design Philosophy

### Visual Design
- **Color Scheme**: Water-inspired blues and cyans
- **Typography**: Clean, readable fonts
- **Spacing**: Generous padding for easy interaction
- **Animations**: Smooth, purposeful motion

### User Experience
- **Simplicity**: One-tap logging
- **Clarity**: Clear progress indicators
- **Feedback**: Immediate visual responses
- **Consistency**: Unified design language

### Accessibility
- High contrast colors
- Large tap targets
- Clear labels and icons
- Readable font sizes

## 🏗️ Technical Architecture

### Layer Structure

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, Navigation)     │
├─────────────────────────────────────┤
│       State Management Layer        │
│     (Riverpod Providers)            │
├─────────────────────────────────────┤
│         Business Logic Layer        │
│  (Services, Data Processing)        │
├─────────────────────────────────────┤
│          Data Layer                 │
│  (Models, Database, Preferences)    │
└─────────────────────────────────────┘
```

### Key Components

#### Models
- **WaterIntake**: Individual water log entries
- **DailyGoal**: User's hydration target
- **Achievement**: Unlockable milestones
- **ReminderSettings**: Notification configuration

#### Services
- **DatabaseService**: SQLite operations
- **PreferencesService**: Settings management
- **NotificationService**: Reminder scheduling

#### Providers
- **WaterProvider**: Central state management
  - Manages today's intake
  - Calculates progress
  - Handles CRUD operations
  - Checks achievements

#### Screens
- **SplashScreen**: App initialization
- **HomeScreen**: Main tracking interface
- **HistoryScreen**: Calendar view
- **StatisticsScreen**: Charts and analytics
- **SettingsScreen**: Configuration
- **MainNavigationScreen**: Bottom nav

#### Widgets
- **CircularWaterProgress**: Animated progress ring
- **AnimatedWaterWave**: Wave animation
- **WaterWavePainter**: Custom wave rendering
- **WaterDropButton**: Preset amount buttons

## 📊 Data Flow

### Adding Water Intake
```
User Taps Button
      ↓
HomeScreen calls provider
      ↓
WaterProvider.addWaterIntake()
      ↓
DatabaseService.createWaterIntake()
      ↓
SQLite stores data
      ↓
Provider updates state
      ↓
UI rebuilds with new progress
      ↓
Achievement check runs
```

### Loading History
```
User navigates to History
      ↓
HistoryScreen.initState()
      ↓
DatabaseService.getDailyTotalsInRange()
      ↓
SQLite query with aggregation
      ↓
Data returned to screen
      ↓
Calendar renders with colors
```

### Scheduling Reminders
```
User enables reminders
      ↓
Settings screen requests permission
      ↓
NotificationService.scheduleReminders()
      ↓
Calculate notification times
      ↓
Schedule with Android/iOS
      ↓
Reminders fire at intervals
```

## 🗄️ Database Schema

### water_intakes Table
```sql
CREATE TABLE water_intakes (
  id TEXT PRIMARY KEY,
  timestamp TEXT NOT NULL,
  amountMl INTEGER NOT NULL,
  date TEXT NOT NULL
);

CREATE INDEX idx_water_intakes_date ON water_intakes(date);
```

### SharedPreferences Keys
- `daily_goal_ml`: Daily goal in milliliters
- `goal_last_updated`: Last goal update timestamp
- `reminder_enabled`: Boolean for reminders
- `reminder_interval`: Minutes between reminders
- `reminder_start_hour/minute`: Start time
- `reminder_end_hour/minute`: End time
- `reminder_days`: Comma-separated day numbers
- `achievements`: JSON array of achievements
- `first_launch`: Boolean for first launch
- `user_name`: Optional user name
- `user_weight`: Optional weight in kg

## 🎯 Use Cases

### Primary Use Case: Daily Tracking
1. User opens app
2. Sees current progress
3. Drinks water
4. Taps preset button
5. Progress updates instantly
6. Continues throughout day
7. Achieves daily goal

### Secondary Use Case: Review History
1. User wants to see past performance
2. Opens History tab
3. Views calendar with color coding
4. Navigates to previous months
5. Checks monthly statistics
6. Identifies patterns

### Tertiary Use Case: Analyze Trends
1. User opens Statistics tab
2. Views weekly bar chart
3. Switches to monthly view
4. Reviews overview statistics
5. Checks achievement progress
6. Sets new goals based on data

## 📱 Screen Specifications

### Home Screen
- **Purpose**: Primary tracking interface
- **Components**:
  - Header with date
  - Circular progress (280x280)
  - Quick add buttons (4 preset + custom)
  - Today's log list
  - Pull-to-refresh
- **Interactions**:
  - Tap buttons to add water
  - Swipe entries to delete
  - Pull down to refresh

### History Screen
- **Purpose**: View past performance
- **Components**:
  - Month selector
  - Calendar grid (7x5)
  - Color legend
  - Monthly statistics card
- **Interactions**:
  - Navigate months
  - View color-coded days
  - Check statistics

### Statistics Screen
- **Purpose**: Analyze trends
- **Components**:
  - Period selector (Week/Month)
  - Bar chart (200px height)
  - Overview card
  - Achievement list
- **Interactions**:
  - Toggle period
  - Tap bars for details
  - Scroll achievements

### Settings Screen
- **Purpose**: Configure app
- **Components**:
  - Goal setting
  - Reminder toggle
  - Interval selector
  - About section
- **Interactions**:
  - Edit goal
  - Enable/disable reminders
  - Select interval

## 🔔 Notification System

### Reminder Logic
1. User sets interval (e.g., 2 hours)
2. User sets active hours (e.g., 8 AM - 10 PM)
3. System calculates notification times
4. Schedules recurring notifications
5. Notifications fire during active hours only
6. Different messages for variety

### Notification Messages
- "Time to hydrate! 💧"
- "Don't forget to drink water! 💦"
- "Stay hydrated! 🌊"
- "Water break time! 💙"
- "Your body needs water! 💧"
- "Drink up! Stay healthy! 💦"
- "Hydration reminder! 🌊"
- "Time for a water break! 💙"

## 🏆 Achievement Details

### Beginner Achievements
1. **First Drop** 💧
   - Trigger: Log first water intake
   - Difficulty: Easy
   - Purpose: Onboarding

2. **3-Day Streak** 🔥
   - Trigger: Meet goal 3 days in a row
   - Difficulty: Easy
   - Purpose: Build habit

### Intermediate Achievements
3. **Week Warrior** ⭐
   - Trigger: 7-day streak
   - Difficulty: Medium
   - Purpose: Consistency

4. **Two Week Champion** 🏆
   - Trigger: 14-day streak
   - Difficulty: Medium
   - Purpose: Long-term habit

### Advanced Achievements
5. **Monthly Master** 👑
   - Trigger: 30-day streak
   - Difficulty: Hard
   - Purpose: Mastery

6. **Perfect Week** 💎
   - Trigger: Exceed goal for 7 days
   - Difficulty: Hard
   - Purpose: Excellence

7. **Hydration Hero** 🦸
   - Trigger: Drink 5L in one day
   - Difficulty: Hard
   - Purpose: Challenge

### Special Achievements
8. **Early Bird** 🌅
   - Trigger: Log before 8 AM for 5 days
   - Difficulty: Medium
   - Purpose: Morning routine

9. **Night Owl** 🌙
   - Trigger: Complete goal after 10 PM
   - Difficulty: Medium
   - Purpose: Late completion

## 🎨 Color Palette

### Primary Colors
- **Sky Blue**: `#0EA5E9` - Main brand color
- **Cyan**: `#06B6D4` - Secondary actions
- **Bright Cyan**: `#22D3EE` - Accents

### Background Colors
- **Very Light Blue**: `#F0F9FF` - App background
- **White**: `#FFFFFF` - Card backgrounds
- **Light Blue Tint**: `#E0F2FE` - Input backgrounds

### Status Colors
- **Success Green**: `#10B981` - Goal achieved
- **Warning Amber**: `#F59E0B` - Warnings
- **Error Red**: `#EF4444` - Errors
- **Info Blue**: `#3B82F6` - Information

### Text Colors
- **Primary**: `#0C4A6E` - Main text
- **Secondary**: `#475569` - Secondary text
- **Hint**: `#94A3B8` - Placeholder text
- **Light**: `#FFFFFF` - Text on dark backgrounds

## 📈 Performance Metrics

### Target Performance
- **App Launch**: < 2 seconds
- **Screen Navigation**: < 300ms
- **Database Query**: < 100ms
- **Animation FPS**: 60fps
- **Memory Usage**: < 100MB

### Optimization Techniques
- Indexed database queries
- Lazy loading of data
- Const constructors
- Efficient rebuilds with Riverpod
- Cached calculations

## 🔒 Privacy & Security

### Data Storage
- **All data stored locally** on device
- No cloud sync or external servers
- No user accounts or authentication
- No personal information collected

### Permissions
- **Notifications**: For reminders only
- **Storage**: For database only
- No location, camera, or contacts access

## 🚀 Future Roadmap

### Phase 1: Enhancement (v1.1)
- [ ] Dark mode support
- [ ] Multiple themes
- [ ] Export data to CSV
- [ ] Import data
- [ ] Backup/restore

### Phase 2: Intelligence (v1.2)
- [ ] Smart goal recommendations
- [ ] Weather-based adjustments
- [ ] Activity level integration
- [ ] Hydration tips
- [ ] Educational content

### Phase 3: Integration (v1.3)
- [ ] Apple Health sync
- [ ] Google Fit sync
- [ ] Wear OS app
- [ ] Apple Watch app
- [ ] Home screen widgets

### Phase 4: Social (v2.0)
- [ ] Share achievements
- [ ] Friend challenges
- [ ] Leaderboards
- [ ] Community features
- [ ] Social media integration

## 📚 Resources

### Documentation
- **README.md**: Project overview and setup
- **QUICKSTART.md**: Getting started guide
- **MIGRATION_GUIDE.md**: Migration from old app
- **TRANSFORMATION_SUMMARY.md**: Detailed changes
- **PROJECT_OVERVIEW.md**: This file

### Code Documentation
- Inline comments for complex logic
- Method documentation for public APIs
- Model documentation for data structures

### External Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [fl_chart Documentation](https://pub.dev/packages/fl_chart)
- [SQLite Documentation](https://www.sqlite.org/docs.html)

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Clone your fork
3. Create a feature branch
4. Make your changes
5. Test thoroughly
6. Submit a pull request

### Code Standards
- Follow Flutter style guide
- Use meaningful variable names
- Add comments for complex logic
- Write clean, readable code
- Test on multiple devices

### Commit Messages
- Use clear, descriptive messages
- Reference issues when applicable
- Follow conventional commits format

## 📞 Support

### Getting Help
1. Check documentation
2. Review code comments
3. Search existing issues
4. Open a new issue
5. Contact maintainers

### Reporting Bugs
Include:
- Device and OS version
- Flutter version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## 📄 License

This project is licensed under the MIT License. See LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- fl_chart for beautiful charts
- The open-source community

---

**Version**: 1.0.0  
**Last Updated**: December 2024  
**Status**: Production Ready ✅  
**Platform**: Android (iOS compatible)  
**Framework**: Flutter 3.5.0+

