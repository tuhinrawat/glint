import 'package:flutter/material.dart';

class GangReminder {
  final String id;
  final String title;
  final String description;
  final DateTime reminderTime;
  final String createdBy;
  final DateTime createdAt;
  final bool isPinned;
  final List<String> notifiedMembers;
  final ReminderPriority priority;

  GangReminder({
    required this.id,
    required this.title,
    required this.description,
    required this.reminderTime,
    required this.createdBy,
    required this.createdAt,
    this.isPinned = false,
    this.notifiedMembers = const [],
    this.priority = ReminderPriority.medium,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'reminderTime': reminderTime.toIso8601String(),
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'isPinned': isPinned,
    'notifiedMembers': notifiedMembers,
    'priority': priority.toString(),
  };

  factory GangReminder.fromJson(Map<String, dynamic> json) => GangReminder(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    reminderTime: DateTime.parse(json['reminderTime'] as String),
    createdBy: json['createdBy'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    isPinned: json['isPinned'] as bool? ?? false,
    notifiedMembers: (json['notifiedMembers'] as List).cast<String>(),
    priority: ReminderPriority.values.firstWhere(
      (e) => e.toString() == json['priority'],
      orElse: () => ReminderPriority.medium,
    ),
  );
}

enum ReminderPriority {
  low,
  medium,
  high,
} 