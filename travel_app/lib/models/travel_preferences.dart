import 'package:flutter/material.dart';

class TravelPreferences {
  final List<String> favoriteDestinationTypes;
  final List<String> travelStyles;
  final List<String> accommodationPreferences;
  final BudgetPreference budgetPreference;
  final List<String> cuisinePreferences;
  final List<String> activities;
  final TripDurationPreference tripDurationPreference;
  final List<String> languages;
  final bool isPublic;

  TravelPreferences({
    required this.favoriteDestinationTypes,
    required this.travelStyles,
    required this.accommodationPreferences,
    required this.budgetPreference,
    required this.cuisinePreferences,
    required this.activities,
    required this.tripDurationPreference,
    required this.languages,
    this.isPublic = true,
  });

  // Predefined options for preferences
  static List<String> destinationTypes = [
    'Beach',
    'Mountains',
    'Cities',
    'Countryside',
    'Islands',
    'Historic Sites',
    'National Parks',
    'Remote Places',
  ];

  static List<String> styles = [
    'Luxury',
    'Budget',
    'Adventure',
    'Cultural',
    'Relaxation',
    'Photography',
    'Food Tourism',
    'Eco-friendly',
  ];

  static List<String> accommodations = [
    'Hotels',
    'Hostels',
    'Resorts',
    'Vacation Rentals',
    'Camping',
    'Glamping',
    'Homestays',
    'Boutique Hotels',
  ];

  static List<String> activityTypes = [
    'Hiking',
    'Swimming',
    'Photography',
    'Food Tours',
    'Museum Visits',
    'Shopping',
    'Local Events',
    'Adventure Sports',
    'Wildlife Watching',
    'Cultural Workshops',
  ];

  factory TravelPreferences.defaultPreferences() {
    return TravelPreferences(
      favoriteDestinationTypes: ['Beach', 'Cities'],
      travelStyles: ['Cultural', 'Adventure'],
      accommodationPreferences: ['Hotels', 'Vacation Rentals'],
      budgetPreference: BudgetPreference.moderate,
      cuisinePreferences: ['Local Cuisine', 'Street Food'],
      activities: ['Hiking', 'Photography', 'Food Tours'],
      tripDurationPreference: TripDurationPreference.medium,
      languages: ['English'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteDestinationTypes': favoriteDestinationTypes,
      'travelStyles': travelStyles,
      'accommodationPreferences': accommodationPreferences,
      'budgetPreference': budgetPreference.toString(),
      'cuisinePreferences': cuisinePreferences,
      'activities': activities,
      'tripDurationPreference': tripDurationPreference.toString(),
      'languages': languages,
      'isPublic': isPublic,
    };
  }

  factory TravelPreferences.fromJson(Map<String, dynamic> json) {
    return TravelPreferences(
      favoriteDestinationTypes: List<String>.from(json['favoriteDestinationTypes']),
      travelStyles: List<String>.from(json['travelStyles']),
      accommodationPreferences: List<String>.from(json['accommodationPreferences']),
      budgetPreference: BudgetPreference.values.firstWhere(
        (e) => e.toString() == json['budgetPreference'],
      ),
      cuisinePreferences: List<String>.from(json['cuisinePreferences']),
      activities: List<String>.from(json['activities']),
      tripDurationPreference: TripDurationPreference.values.firstWhere(
        (e) => e.toString() == json['tripDurationPreference'],
      ),
      languages: List<String>.from(json['languages']),
      isPublic: json['isPublic'] ?? true,
    );
  }
}

enum BudgetPreference {
  budget,
  moderate,
  luxury,
  ultraLuxury
}

enum TripDurationPreference {
  short,    // 1-3 days
  medium,   // 4-7 days
  long,     // 1-2 weeks
  extended  // 2+ weeks
} 