enum AchievementType {
  firstDrop,
  threeDayStreak,
  weekStreak,
  twoWeekStreak,
  monthStreak,
  perfectWeek,
  hydrationHero,
  earlyBird,
  nightOwl,
}

class Achievement {
  final AchievementType type;
  final String title;
  final String description;
  final String icon;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'title': title,
      'description': description,
      'icon': icon,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'isUnlocked': isUnlocked,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      type: AchievementType.values.firstWhere(
        (e) => e.name == map['type'],
      ),
      title: map['title'] as String,
      description: map['description'] as String,
      icon: map['icon'] as String,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'] as String)
          : null,
      isUnlocked: map['isUnlocked'] as bool,
    );
  }

  Achievement copyWith({
    AchievementType? type,
    String? title,
    String? description,
    String? icon,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Achievement(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static List<Achievement> getDefaultAchievements() {
    return [
      Achievement(
        type: AchievementType.firstDrop,
        title: 'First Drop',
        description: 'Log your first water intake',
        icon: '💧',
      ),
      Achievement(
        type: AchievementType.threeDayStreak,
        title: '3-Day Streak',
        description: 'Meet your goal for 3 days in a row',
        icon: '🔥',
      ),
      Achievement(
        type: AchievementType.weekStreak,
        title: 'Week Warrior',
        description: 'Meet your goal for 7 days in a row',
        icon: '⭐',
      ),
      Achievement(
        type: AchievementType.twoWeekStreak,
        title: 'Two Week Champion',
        description: 'Meet your goal for 14 days in a row',
        icon: '🏆',
      ),
      Achievement(
        type: AchievementType.monthStreak,
        title: 'Monthly Master',
        description: 'Meet your goal for 30 days in a row',
        icon: '👑',
      ),
      Achievement(
        type: AchievementType.perfectWeek,
        title: 'Perfect Week',
        description: 'Exceed your goal every day for a week',
        icon: '💎',
      ),
      Achievement(
        type: AchievementType.hydrationHero,
        title: 'Hydration Hero',
        description: 'Drink 5 liters in a single day',
        icon: '🦸',
      ),
      Achievement(
        type: AchievementType.earlyBird,
        title: 'Early Bird',
        description: 'Log water before 8 AM for 5 days',
        icon: '🌅',
      ),
      Achievement(
        type: AchievementType.nightOwl,
        title: 'Night Owl',
        description: 'Complete your goal after 10 PM',
        icon: '🌙',
      ),
    ];
  }
}

