import 'package:flutter/material.dart';

class GangChecklist {
  final String id;
  final String title;
  final List<ChecklistItem> items;
  final Map<String, List<String>> memberCompletions; // memberId -> completed item ids
  final DateTime createdAt;
  final String createdBy;
  final bool isPinned;

  GangChecklist({
    required this.id,
    required this.title,
    required this.items,
    required this.memberCompletions,
    required this.createdAt,
    required this.createdBy,
    this.isPinned = false,
  });

  int get totalMembers => memberCompletions.length;
  int get completedMembers => memberCompletions.values
      .where((completedItems) => completedItems.length == items.length)
      .length;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'items': items.map((item) => item.toJson()).toList(),
    'memberCompletions': memberCompletions,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy,
    'isPinned': isPinned,
  };

  factory GangChecklist.fromJson(Map<String, dynamic> json) => GangChecklist(
    id: json['id'] as String,
    title: json['title'] as String,
    items: (json['items'] as List)
        .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
        .toList(),
    memberCompletions: Map<String, List<String>>.from(
      json['memberCompletions'] as Map<String, dynamic>,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    createdBy: json['createdBy'] as String,
    isPinned: json['isPinned'] as bool? ?? false,
  );
}

class ChecklistItem {
  final String id;
  final String title;
  final String? description;
  final ChecklistCategory category;

  ChecklistItem({
    required this.id,
    required this.title,
    this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category.toString(),
  };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    category: ChecklistCategory.values.firstWhere(
      (e) => e.toString() == json['category'],
      orElse: () => ChecklistCategory.general,
    ),
  );
}

enum ChecklistCategory {
  documents,
  essentials,
  clothing,
  electronics,
  toiletries,
  medical,
  general,
} 