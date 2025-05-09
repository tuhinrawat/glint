import 'package:flutter/material.dart';
import '../models/travel_preferences.dart';

class Gang {
  final String id;
  final String name;
  final String description;
  final List<GangMember> members;
  final DateTime createdAt;
  final String createdBy;
  final TravelPreferences groupPreferences;
  final String avatar;

  Gang({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.createdAt,
    required this.createdBy,
    required this.groupPreferences,
    this.avatar = 'https://images.unsplash.com/photo-1478145046317-39f10e56b5e9',
  });

  Gang copyWith({
    String? id,
    String? name,
    String? description,
    List<GangMember>? members,
    DateTime? createdAt,
    String? createdBy,
    TravelPreferences? groupPreferences,
    String? avatar,
  }) {
    return Gang(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      groupPreferences: groupPreferences ?? this.groupPreferences,
      avatar: avatar ?? this.avatar,
    );
  }

  // Calculate group preferences based on member preferences
  static TravelPreferences calculateGroupPreferences(List<GangMember> members) {
    if (members.isEmpty) {
      return TravelPreferences.defaultPreferences();
    }

    // Aggregate destination types
    final allDestinations = members
        .expand((m) => m.preferences.favoriteDestinationTypes)
        .toSet()
        .toList();

    // Aggregate travel styles
    final allStyles = members
        .expand((m) => m.preferences.travelStyles)
        .toSet()
        .toList();

    // Calculate most common budget preference
    final budgetCounts = <BudgetPreference, int>{};
    for (var member in members) {
      budgetCounts[member.preferences.budgetPreference] = 
          (budgetCounts[member.preferences.budgetPreference] ?? 0) + 1;
    }
    final commonBudget = budgetCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Aggregate accommodation preferences
    final allAccommodations = members
        .expand((m) => m.preferences.accommodationPreferences)
        .toSet()
        .toList();

    // Calculate most common trip duration
    final durationCounts = <TripDurationPreference, int>{};
    for (var member in members) {
      durationCounts[member.preferences.tripDurationPreference] = 
          (durationCounts[member.preferences.tripDurationPreference] ?? 0) + 1;
    }
    final commonDuration = durationCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Aggregate activities
    final allActivities = members
        .expand((m) => m.preferences.activities)
        .toSet()
        .toList();

    // Aggregate cuisines
    final allCuisines = members
        .expand((m) => m.preferences.cuisinePreferences)
        .toSet()
        .toList();

    // Aggregate languages
    final allLanguages = members
        .expand((m) => m.preferences.languages)
        .toSet()
        .toList();

    return TravelPreferences(
      favoriteDestinationTypes: allDestinations,
      travelStyles: allStyles,
      accommodationPreferences: allAccommodations,
      budgetPreference: commonBudget,
      cuisinePreferences: allCuisines,
      activities: allActivities,
      tripDurationPreference: commonDuration,
      languages: allLanguages,
      isPublic: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'members': members.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'groupPreferences': groupPreferences.toJson(),
      'avatar': avatar,
    };
  }

  factory Gang.fromJson(Map<String, dynamic> json) {
    return Gang(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      members: (json['members'] as List)
          .map((m) => GangMember.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      groupPreferences: TravelPreferences.fromJson(
        json['groupPreferences'] as Map<String, dynamic>,
      ),
      avatar: json['avatar'] as String? ?? 'https://images.unsplash.com/photo-1478145046317-39f10e56b5e9',
    );
  }
}

class GangMember {
  final String id;
  final String name;
  final String? avatarUrl;
  final String email;
  final TravelPreferences preferences;

  GangMember({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.email,
    required this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'email': email,
      'preferences': preferences.toJson(),
    };
  }

  factory GangMember.fromJson(Map<String, dynamic> json) {
    return GangMember(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String,
      preferences: TravelPreferences.fromJson(
        json['preferences'] as Map<String, dynamic>,
      ),
    );
  }
} 