import 'package:flutter/material.dart';

class GangWellbeing {
  final String id;
  final String memberId;
  final DateTime checkedAt;
  final WellbeingStatus status;
  final String? note;
  final List<WellbeingSymptom> symptoms;
  final bool isPinned;

  GangWellbeing({
    required this.id,
    required this.memberId,
    required this.checkedAt,
    required this.status,
    this.note,
    this.symptoms = const [],
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'memberId': memberId,
    'checkedAt': checkedAt.toIso8601String(),
    'status': status.toString(),
    'note': note,
    'symptoms': symptoms.map((s) => s.toString()).toList(),
    'isPinned': isPinned,
  };

  factory GangWellbeing.fromJson(Map<String, dynamic> json) => GangWellbeing(
    id: json['id'] as String,
    memberId: json['memberId'] as String,
    checkedAt: DateTime.parse(json['checkedAt'] as String),
    status: WellbeingStatus.values.firstWhere(
      (e) => e.toString() == json['status'],
      orElse: () => WellbeingStatus.good,
    ),
    note: json['note'] as String?,
    symptoms: (json['symptoms'] as List).map((s) => WellbeingSymptom.values.firstWhere(
      (e) => e.toString() == s,
      orElse: () => WellbeingSymptom.none,
    )).toList(),
    isPinned: json['isPinned'] as bool? ?? false,
  );
}

enum WellbeingStatus {
  excellent,
  good,
  okay,
  notWell,
  sick,
}

enum WellbeingSymptom {
  none,
  fever,
  cough,
  soreThroat,
  headache,
  fatigue,
  nausea,
  diarrhea,
  muscleAche,
  other,
} 