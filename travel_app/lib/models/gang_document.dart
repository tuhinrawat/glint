import 'package:flutter/material.dart';

class GangDocument {
  final String id;
  final String name;
  final String url;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String type; // pdf, image, etc.
  final bool isPinned;

  GangDocument({
    required this.id,
    required this.name,
    required this.url,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.type,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'uploadedBy': uploadedBy,
    'uploadedAt': uploadedAt.toIso8601String(),
    'type': type,
    'isPinned': isPinned,
  };

  factory GangDocument.fromJson(Map<String, dynamic> json) => GangDocument(
    id: json['id'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
    uploadedBy: json['uploadedBy'] as String,
    uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    type: json['type'] as String,
    isPinned: json['isPinned'] as bool? ?? false,
  );
} 