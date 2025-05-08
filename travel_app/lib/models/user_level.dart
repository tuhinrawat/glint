class UserLevel {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final int requiredPoints;
  final List<String> perks;

  const UserLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.requiredPoints,
    required this.perks,
  });

  static List<UserLevel> allLevels = [
    UserLevel(
      id: 'novice',
      title: 'Novice Explorer',
      description: 'Taking your first steps into the world of travel',
      iconPath: 'assets/icons/levels/novice.png',
      requiredPoints: 0,
      perks: ['Access to basic features'],
    ),
    UserLevel(
      id: 'adventurer',
      title: 'Adventurer',
      description: 'Starting to explore and share your journeys',
      iconPath: 'assets/icons/levels/adventurer.png',
      requiredPoints: 100,
      perks: ['5% discount on selected bookings', 'Custom profile badge'],
    ),
    UserLevel(
      id: 'voyager',
      title: 'Voyager',
      description: 'Expanding your horizons to new destinations',
      iconPath: 'assets/icons/levels/voyager.png',
      requiredPoints: 300,
      perks: ['10% discount on selected bookings', 'Priority customer support'],
    ),
    UserLevel(
      id: 'explorer',
      title: 'Seasoned Explorer',
      description: 'A traveler with rich experiences across multiple journeys',
      iconPath: 'assets/icons/levels/explorer.png',
      requiredPoints: 750,
      perks: ['15% discount on selected bookings', 'Exclusive travel guides', 'Early access to new features'],
    ),
    UserLevel(
      id: 'globetrotter',
      title: 'Globetrotter',
      description: 'A world traveler with extensive experience across continents',
      iconPath: 'assets/icons/levels/globetrotter.png',
      requiredPoints: 1500,
      perks: ['20% discount on selected bookings', 'Invite to exclusive events', 'Personalized travel recommendations'],
    ),
    UserLevel(
      id: 'nomad',
      title: 'Digital Nomad',
      description: 'Living the travel lifestyle and inspiring others',
      iconPath: 'assets/icons/levels/nomad.png',
      requiredPoints: 3000,
      perks: ['25% discount on selected bookings', 'VIP customer support', 'Complimentary travel perks'],
    ),
    UserLevel(
      id: 'master',
      title: 'Travel Master',
      description: 'An elite traveler and influential community member',
      iconPath: 'assets/icons/levels/master.png',
      requiredPoints: 5000,
      perks: ['30% discount on all bookings', 'Featured profile highlights', 'Influence on app features'],
    ),
  ];

  static UserLevel getLevelForPoints(int points) {
    // Find the highest level the user qualifies for
    for (int i = allLevels.length - 1; i >= 0; i--) {
      if (points >= allLevels[i].requiredPoints) {
        return allLevels[i];
      }
    }
    // Default to novice
    return allLevels.first;
  }

  static UserLevel getNextLevel(int currentPoints) {
    for (var level in allLevels) {
      if (currentPoints < level.requiredPoints) {
        return level;
      }
    }
    // If already at max level, return the max level
    return allLevels.last;
  }

  static double getProgressToNextLevel(int currentPoints) {
    final UserLevel currentLevel = getLevelForPoints(currentPoints);
    final int currentLevelIndex = allLevels.indexOf(currentLevel);
    
    if (currentLevelIndex == allLevels.length - 1) {
      // Already at max level
      return 1.0;
    }
    
    final UserLevel nextLevel = allLevels[currentLevelIndex + 1];
    final int pointsRequired = nextLevel.requiredPoints - currentLevel.requiredPoints;
    final int pointsEarned = currentPoints - currentLevel.requiredPoints;
    
    return pointsEarned / pointsRequired;
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final int pointsAwarded;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.pointsAwarded,
    this.isUnlocked = false,
  });

  // Create a copy with different isUnlocked status
  Achievement copyWith({bool? isUnlocked}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      iconPath: iconPath,
      pointsAwarded: pointsAwarded,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static List<Achievement> allAchievements = [
    // Trip-based achievements
    Achievement(
      id: 'first_trip',
      title: 'First Steps',
      description: 'Book your first trip',
      iconPath: 'assets/icons/achievements/first_trip.png',
      pointsAwarded: 50,
    ),
    Achievement(
      id: 'trip_3',
      title: 'Getting Started',
      description: 'Book 3 trips',
      iconPath: 'assets/icons/achievements/trip_3.png',
      pointsAwarded: 100,
    ),
    Achievement(
      id: 'trip_5',
      title: 'Regular Traveler',
      description: 'Book 5 trips',
      iconPath: 'assets/icons/achievements/trip_5.png',
      pointsAwarded: 150,
    ),
    Achievement(
      id: 'trip_10',
      title: 'Travel Enthusiast',
      description: 'Book 10 trips',
      iconPath: 'assets/icons/achievements/trip_10.png',
      pointsAwarded: 300,
    ),
    Achievement(
      id: 'trip_25',
      title: 'Travel Addict',
      description: 'Book 25 trips',
      iconPath: 'assets/icons/achievements/trip_25.png',
      pointsAwarded: 500,
    ),
    
    // Experience-based achievements
    Achievement(
      id: 'first_post',
      title: 'First Share',
      description: 'Share your first experience',
      iconPath: 'assets/icons/achievements/first_post.png',
      pointsAwarded: 50,
    ),
    Achievement(
      id: 'posts_10',
      title: 'Active Sharer',
      description: 'Share 10 experiences',
      iconPath: 'assets/icons/achievements/posts_10.png',
      pointsAwarded: 200,
    ),
    Achievement(
      id: 'posts_50',
      title: 'Travel Influencer',
      description: 'Share 50 experiences',
      iconPath: 'assets/icons/achievements/posts_50.png',
      pointsAwarded: 500,
    ),
    
    // Engagement achievements
    Achievement(
      id: 'likes_100',
      title: 'Popular Traveler',
      description: 'Receive 100 likes on your experiences',
      iconPath: 'assets/icons/achievements/likes_100.png',
      pointsAwarded: 150,
    ),
    Achievement(
      id: 'likes_1000',
      title: 'Travel Star',
      description: 'Receive 1,000 likes on your experiences',
      iconPath: 'assets/icons/achievements/likes_1000.png',
      pointsAwarded: 500,
    ),
    
    // Social achievements
    Achievement(
      id: 'first_gang',
      title: 'Travel Buddy',
      description: 'Join or create your first travel gang',
      iconPath: 'assets/icons/achievements/first_gang.png',
      pointsAwarded: 100,
    ),
    Achievement(
      id: 'gang_trip',
      title: 'Group Adventure',
      description: 'Book a trip with your travel gang',
      iconPath: 'assets/icons/achievements/gang_trip.png',
      pointsAwarded: 200,
    ),
    
    // Destination achievements
    Achievement(
      id: 'countries_3',
      title: 'Border Hopper',
      description: 'Visit 3 different countries',
      iconPath: 'assets/icons/achievements/countries_3.png',
      pointsAwarded: 200,
    ),
    Achievement(
      id: 'countries_10',
      title: 'Continental Explorer',
      description: 'Visit 10 different countries',
      iconPath: 'assets/icons/achievements/countries_10.png',
      pointsAwarded: 500,
    ),
    Achievement(
      id: 'continents_3',
      title: 'World Traveler',
      description: 'Visit 3 different continents',
      iconPath: 'assets/icons/achievements/continents_3.png',
      pointsAwarded: 300,
    ),
  ];
} 