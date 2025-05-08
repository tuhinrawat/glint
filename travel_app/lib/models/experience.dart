import 'package:flutter/material.dart';
import 'itinerary.dart';

class Experience {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String title;
  final String description;
  final List<ExperienceMedia> media;
  final List<String> locations;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> tags;
  final Itinerary? itinerary;
  final int likes;
  final int dislikes;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Experience({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.title,
    required this.description,
    required this.media,
    required this.locations,
    required this.startDate,
    this.endDate,
    required this.tags,
    this.itinerary,
    this.likes = 0,
    this.dislikes = 0,
    this.isPublic = true,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'title': title,
      'description': description,
      'media': media.map((m) => m.toJson()).toList(),
      'locations': locations,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'tags': tags,
      'itinerary': itinerary?.toJson(),
      'likes': likes,
      'dislikes': dislikes,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      title: json['title'],
      description: json['description'],
      media: (json['media'] as List).map((m) => ExperienceMedia.fromJson(m)).toList(),
      locations: List<String>.from(json['locations']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      tags: List<String>.from(json['tags']),
      itinerary: json['itinerary'] != null ? Itinerary.fromJson(json['itinerary']) : null,
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      isPublic: json['isPublic'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

class ExperienceMedia {
  final String id;
  final String url;
  final MediaType type;
  final String? caption;
  final String? location;
  final DateTime timestamp;

  ExperienceMedia({
    required this.id,
    required this.url,
    required this.type,
    this.caption,
    this.location,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type.toString(),
      'caption': caption,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ExperienceMedia.fromJson(Map<String, dynamic> json) {
    return ExperienceMedia(
      id: json['id'],
      url: json['url'],
      type: MediaType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MediaType.image,
      ),
      caption: json['caption'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

enum MediaType {
  image,
  video,
  panorama,
} 