# AquaTrack - Quick Start Guide

## Installation & Setup

### Step 1: Install Dependencies

Run the following command in your project directory:

```bash
flutter pub get
```

This will install all required packages including:
- flutter_riverpod (state management)
- sqflite (local database)
- flutter_local_notifications (reminders)
- fl_chart (statistics charts)
- And more...

### Step 2: Run the App

For development:
```bash
flutter run
```

For release build:
```bash
flutter build apk --release
```

## First Time Setup

When you first launch AquaTrack:

1. **Splash Screen**: You'll see the animated AquaTrack logo with water waves
2. **Home Screen**: The app opens to the home screen showing 0% progress
3. **Set Your Goal**: Go to Settings → Daily Water Goal and set your target (default is 2.5L)
4. **Enable Reminders**: Go to Settings → Enable Reminders and grant notification permissions

## Basic Usage

### Logging Water Intake

**Method 1: Quick Add (Recommended)**
1. On the home screen, tap one of the preset buttons:
   - 250ml (small glass)
   - 500ml (standard bottle)
   - 750ml (large bottle)
   - 1L (1 liter)

**Method 2: Custom Amount**
1. Tap the "Custom" button
2. Enter any amount between 1-5000ml
3. Tap "Add"

### Viewing Progress

**Home Screen**
- Large circular progress indicator shows today's progress
- Percentage and current/goal amounts displayed
- "Goal Achieved! 🎉" badge appears when you reach 100%
- Today's log shows all entries with timestamps

**History Screen**
- Calendar view with color-coded days
- Monthly statistics at the bottom
- Navigate between months using arrow buttons

**Statistics Screen**
- Toggle between Week and Month views
- Interactive bar charts
- Overview statistics
- Achievement progress

### Managing Entries

**Delete an Entry**
- On the home screen, swipe left on any entry
- Confirm deletion

**Refresh Data**
- Pull down on the home screen to refresh

## Settings Configuration

### Daily Goal

1. Go to Settings
2. Tap "Daily Water Goal"
3. Enter goal in liters (e.g., 2.5)
4. Tap "Save"

**Recommended Goals:**
- Sedentary lifestyle: 2.0L
- Moderate activity: 2.5L
- Active lifestyle: 3.0L
- Athletic/Hot climate: 3.5L+

### Reminders

1. Go to Settings
2. Enable "Reminders" toggle
3. Grant notification permissions
4. Tap "Reminder Interval"
5. Choose frequency:
   - Every 30 minutes
   - Every hour
   - Every 2 hours
   - Every 3 hours

**Tips:**
- Set reminders for your waking hours
- More frequent reminders help build the habit
- You can always disable reminders temporarily

## Understanding the Calendar

The History screen uses color coding:

- **Grey**: No water logged that day
- **Very Light Blue**: Less than 50% of goal
- **Light Blue**: 50-75% of goal
- **Blue**: 75-100% of goal
- **Dark Blue**: 100% or more (goal exceeded!)

Days with a border are today's date.

## Achievements System

Unlock achievements by maintaining good habits:

**Beginner:**
- First Drop: Log your first intake
- 3-Day Streak: Meet goal for 3 days

**Intermediate:**
- Week Warrior: 7-day streak
- Two Week Champion: 14-day streak

**Advanced:**
- Monthly Master: 30-day streak
- Perfect Week: Exceed goal for 7 days
- Hydration Hero: Drink 5L in one day

**Special:**
- Early Bird: Log before 8 AM for 5 days
- Night Owl: Complete goal after 10 PM

View your achievements in the Statistics screen.

## Tips for Success

### Building the Habit

1. **Start Small**: Begin with a realistic goal
2. **Use Reminders**: Enable notifications to build consistency
3. **Track Consistently**: Log every glass, even small amounts
4. **Visual Motivation**: Check your progress throughout the day
5. **Celebrate Streaks**: Try to maintain your streak!

### Optimal Hydration

- Drink water throughout the day, not all at once
- Drink more during exercise or hot weather
- Morning hydration: Start your day with 250-500ml
- Before meals: Drink water 30 minutes before eating
- Listen to your body: Thirst is a late indicator

### Using the Charts

- **Weekly View**: See daily patterns and identify low days
- **Monthly View**: Track long-term trends
- **Best Day**: Try to beat your personal record!
- **Average**: Aim to increase your average over time

## Troubleshooting

### Notifications Not Working

1. Check Settings → Reminders is enabled
2. Verify notification permissions in phone settings
3. Ensure "Do Not Disturb" is not blocking notifications
4. Try disabling and re-enabling reminders

### Data Not Saving

1. Check storage permissions
2. Ensure sufficient device storage
3. Try force-closing and reopening the app

### Progress Not Updating

1. Pull down on home screen to refresh
2. Check that entries are being saved (view Today's Log)
3. Restart the app if needed

## Keyboard Shortcuts (Development)

When running in debug mode:
- `r`: Hot reload
- `R`: Hot restart
- `q`: Quit

## Support

For issues or questions:
1. Check this guide first
2. Review the main README.md
3. Open an issue on GitHub
4. Contact the development team

---

**Remember: Consistency is key! Aim for your goal every day, and you'll see improvements in your energy, focus, and overall health. 💧**

