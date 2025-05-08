import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_level.dart';

class GamificationService {
  static const String _pointsKey = 'user_points';
  static const String _achievementsKey = 'user_achievements';
  static const String _tripsKey = 'user_trips_count';
  static const String _postsKey = 'user_posts_count';
  static const String _likesKey = 'user_likes_count';
  static const String _gangsKey = 'user_gangs_count';
  static const String _countriesKey = 'user_countries_count';
  static const String _continentsKey = 'user_continents_count';

  // Get user's current points
  Future<int> getUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pointsKey) ?? 0;
  }

  // Add points to the user
  Future<void> addPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPoints = prefs.getInt(_pointsKey) ?? 0;
    await prefs.setInt(_pointsKey, currentPoints + points);
  }

  // Get user's unlocked achievements
  Future<List<String>> getUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_achievementsKey) ?? [];
  }

  // Unlock a new achievement and award points
  Future<bool> unlockAchievement(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedIds = prefs.getStringList(_achievementsKey) ?? [];
    
    // Check if already unlocked
    if (unlockedIds.contains(achievementId)) {
      return false;
    }
    
    // Find the achievement to get points
    final achievement = Achievement.allAchievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => Achievement(
        id: achievementId,
        title: 'Unknown',
        description: 'Unknown achievement',
        iconPath: 'assets/icons/achievements/default.png',
        pointsAwarded: 0,
      ),
    );
    
    // Add achievement to unlocked list
    unlockedIds.add(achievementId);
    await prefs.setStringList(_achievementsKey, unlockedIds);
    
    // Award points
    await addPoints(achievement.pointsAwarded);
    
    return true;
  }

  // Get all achievements with unlocked status
  Future<List<Achievement>> getAllAchievements() async {
    final unlockedIds = await getUnlockedAchievements();
    
    return Achievement.allAchievements.map((achievement) {
      return achievement.copyWith(
        isUnlocked: unlockedIds.contains(achievement.id),
      );
    }).toList();
  }

  // Get the user's current level
  Future<UserLevel> getUserLevel() async {
    final points = await getUserPoints();
    return UserLevel.getLevelForPoints(points);
  }

  // Get the next level the user can reach
  Future<UserLevel> getNextLevel() async {
    final points = await getUserPoints();
    return UserLevel.getNextLevel(points);
  }

  // Get progress to next level (0.0 to 1.0)
  Future<double> getProgressToNextLevel() async {
    final points = await getUserPoints();
    return UserLevel.getProgressToNextLevel(points);
  }

  // Record a new trip and check for achievements
  Future<List<Achievement>> recordNewTrip() async {
    final prefs = await SharedPreferences.getInstance();
    final tripCount = (prefs.getInt(_tripsKey) ?? 0) + 1;
    await prefs.setInt(_tripsKey, tripCount);
    
    // Check for trip-based achievements
    final newAchievements = <Achievement>[];
    
    if (tripCount == 1) {
      final unlocked = await unlockAchievement('first_trip');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'first_trip').copyWith(isUnlocked: true));
      }
    }
    
    if (tripCount == 3) {
      final unlocked = await unlockAchievement('trip_3');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'trip_3').copyWith(isUnlocked: true));
      }
    }
    
    if (tripCount == 5) {
      final unlocked = await unlockAchievement('trip_5');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'trip_5').copyWith(isUnlocked: true));
      }
    }
    
    if (tripCount == 10) {
      final unlocked = await unlockAchievement('trip_10');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'trip_10').copyWith(isUnlocked: true));
      }
    }
    
    if (tripCount == 25) {
      final unlocked = await unlockAchievement('trip_25');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'trip_25').copyWith(isUnlocked: true));
      }
    }
    
    return newAchievements;
  }

  // Record a new post/experience and check for achievements
  Future<List<Achievement>> recordNewPost() async {
    final prefs = await SharedPreferences.getInstance();
    final postCount = (prefs.getInt(_postsKey) ?? 0) + 1;
    await prefs.setInt(_postsKey, postCount);
    
    // Check for post-based achievements
    final newAchievements = <Achievement>[];
    
    if (postCount == 1) {
      final unlocked = await unlockAchievement('first_post');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'first_post').copyWith(isUnlocked: true));
      }
    }
    
    if (postCount == 10) {
      final unlocked = await unlockAchievement('posts_10');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'posts_10').copyWith(isUnlocked: true));
      }
    }
    
    if (postCount == 50) {
      final unlocked = await unlockAchievement('posts_50');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'posts_50').copyWith(isUnlocked: true));
      }
    }
    
    return newAchievements;
  }

  // Record a new like received and check for achievements
  Future<List<Achievement>> recordNewLike() async {
    final prefs = await SharedPreferences.getInstance();
    final likeCount = (prefs.getInt(_likesKey) ?? 0) + 1;
    await prefs.setInt(_likesKey, likeCount);
    
    // Check for like-based achievements
    final newAchievements = <Achievement>[];
    
    if (likeCount == 100) {
      final unlocked = await unlockAchievement('likes_100');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'likes_100').copyWith(isUnlocked: true));
      }
    }
    
    if (likeCount == 1000) {
      final unlocked = await unlockAchievement('likes_1000');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'likes_1000').copyWith(isUnlocked: true));
      }
    }
    
    return newAchievements;
  }

  // Record a new gang (create or join) and check for achievements
  Future<List<Achievement>> recordNewGang() async {
    final prefs = await SharedPreferences.getInstance();
    final gangCount = (prefs.getInt(_gangsKey) ?? 0) + 1;
    await prefs.setInt(_gangsKey, gangCount);
    
    // Check for gang-based achievements
    final newAchievements = <Achievement>[];
    
    if (gangCount == 1) {
      final unlocked = await unlockAchievement('first_gang');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'first_gang').copyWith(isUnlocked: true));
      }
    }
    
    return newAchievements;
  }

  // Record a gang trip and check for achievements
  Future<List<Achievement>> recordGangTrip() async {
    // Check for gang trip achievement
    final newAchievements = <Achievement>[];
    
    final unlocked = await unlockAchievement('gang_trip');
    if (unlocked) {
      newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'gang_trip').copyWith(isUnlocked: true));
    }
    
    return newAchievements;
  }

  // Record a new country visited and check for achievements
  Future<List<Achievement>> recordNewCountry() async {
    final prefs = await SharedPreferences.getInstance();
    final countryCount = (prefs.getInt(_countriesKey) ?? 0) + 1;
    await prefs.setInt(_countriesKey, countryCount);
    
    // Check for country-based achievements
    final newAchievements = <Achievement>[];
    
    if (countryCount == 3) {
      final unlocked = await unlockAchievement('countries_3');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'countries_3').copyWith(isUnlocked: true));
      }
    }
    
    if (countryCount == 10) {
      final unlocked = await unlockAchievement('countries_10');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'countries_10').copyWith(isUnlocked: true));
      }
    }
    
    return newAchievements;
  }

  // Record a new continent visited and check for achievements
  Future<List<Achievement>> recordNewContinent() async {
    final prefs = await SharedPreferences.getInstance();
    final continentCount = (prefs.getInt(_continentsKey) ?? 0) + 1;
    await prefs.setInt(_continentsKey, continentCount);
    
    // Check for continent-based achievements
    final newAchievements = <Achievement>[];
    
    if (continentCount == 3) {
      final unlocked = await unlockAchievement('continents_3');
      if (unlocked) {
        newAchievements.add(Achievement.allAchievements.firstWhere((a) => a.id == 'continents_3').copyWith(isUnlocked: true));
      }
    }
    
    return newAchievements;
  }

  // Get all stats for the user
  Future<Map<String, int>> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'points': prefs.getInt(_pointsKey) ?? 0,
      'trips': prefs.getInt(_tripsKey) ?? 0,
      'posts': prefs.getInt(_postsKey) ?? 0,
      'likes': prefs.getInt(_likesKey) ?? 0,
      'gangs': prefs.getInt(_gangsKey) ?? 0,
      'countries': prefs.getInt(_countriesKey) ?? 0,
      'continents': prefs.getInt(_continentsKey) ?? 0,
    };
  }

  // Reset all gamification data (for testing)
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pointsKey);
    await prefs.remove(_achievementsKey);
    await prefs.remove(_tripsKey);
    await prefs.remove(_postsKey);
    await prefs.remove(_likesKey);
    await prefs.remove(_gangsKey);
    await prefs.remove(_countriesKey);
    await prefs.remove(_continentsKey);
  }
} 