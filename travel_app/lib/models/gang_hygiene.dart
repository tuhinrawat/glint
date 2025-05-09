import 'package:flutter/material.dart';

class GangHygiene {
  final String id;
  final String memberId;
  final DateTime checkedAt;
  final List<HygieneItem> completedItems;
  final String? note;
  final bool isPinned;

  GangHygiene({
    required this.id,
    required this.memberId,
    required this.checkedAt,
    required this.completedItems,
    this.note,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'memberId': memberId,
    'checkedAt': checkedAt.toIso8601String(),
    'completedItems': completedItems.map((item) => item.toString()).toList(),
    'note': note,
    'isPinned': isPinned,
  };

  factory GangHygiene.fromJson(Map<String, dynamic> json) => GangHygiene(
    id: json['id'] as String,
    memberId: json['memberId'] as String,
    checkedAt: DateTime.parse(json['checkedAt'] as String),
    completedItems: (json['completedItems'] as List).map((item) => HygieneItem.values.firstWhere(
      (e) => e.toString() == item,
      orElse: () => HygieneItem.none,
    )).toList(),
    note: json['note'] as String?,
    isPinned: json['isPinned'] as bool? ?? false,
  );
}

enum HygieneItem {
  none,
  handWashing,
  maskWearing,
  socialDistancing,
  sanitizerUse,
  cleanEnvironment,
  properVentilation,
  foodSafety,
  waterSafety,
  personalHygiene,
  other,
} 