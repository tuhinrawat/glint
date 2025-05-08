import 'dart:io';
import 'package:flutter/material.dart';
import '../models/experience.dart';
import '../models/itinerary.dart';

class ExperienceService {
  // Singleton instance
  static final ExperienceService _instance = ExperienceService._internal();
  factory ExperienceService() => _instance;
  ExperienceService._internal();

  // In-memory storage (replace with backend in production)
  final List<Experience> _experiences = [];

  // Create a new experience
  Future<Experience> createExperience({
    required String userId,
    required String userName,
    String? userAvatar,
    required String title,
    required String description,
    required List<File> mediaFiles,
    required List<String> locations,
    required DateTime startDate,
    DateTime? endDate,
    required List<String> tags,
    Itinerary? itinerary,
    bool isPublic = true,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would:
    // 1. Upload media files to cloud storage
    // 2. Create experience in backend
    // 3. Return the created experience

    final now = DateTime.now();
    final experience = Experience(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      title: title,
      description: description,
      media: mediaFiles.map((file) => ExperienceMedia(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        url: file.path, // In real app, this would be cloud storage URL
        type: MediaType.image,
        timestamp: now,
      )).toList(),
      locations: locations,
      startDate: startDate,
      endDate: endDate,
      tags: tags,
      itinerary: itinerary,
      createdAt: now,
    );

    _experiences.add(experience);
    return experience;
  }

  // Get feed for a user
  Future<List<Experience>> getFeed({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would:
    // 1. Get personalized feed from backend
    // 2. Apply filters based on user preferences
    // 3. Handle pagination

    final start = (page - 1) * limit;
    final end = start + limit;
    return _experiences
        .where((e) => e.isPublic || e.userId == userId)
        .skip(start)
        .take(limit)
        .toList();
  }

  // Like/unlike an experience
  Future<void> toggleLike(String experienceId, String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));

    final experience = _experiences.firstWhere((e) => e.id == experienceId);
    final index = _experiences.indexOf(experience);
    
    // In a real app, this would update the backend
    _experiences[index] = Experience(
      id: experience.id,
      userId: experience.userId,
      userName: experience.userName,
      userAvatar: experience.userAvatar,
      title: experience.title,
      description: experience.description,
      media: experience.media,
      locations: experience.locations,
      startDate: experience.startDate,
      endDate: experience.endDate,
      tags: experience.tags,
      itinerary: experience.itinerary,
      likes: experience.likes + 1,
      dislikes: experience.dislikes,
      isPublic: experience.isPublic,
      createdAt: experience.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Get experiences by user
  Future<List<Experience>> getUserExperiences(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _experiences.where((e) => e.userId == userId).toList();
  }

  // Delete an experience
  Future<void> deleteExperience(String experienceId, String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final experience = _experiences.firstWhere(
      (e) => e.id == experienceId && e.userId == userId,
      orElse: () => throw Exception('Experience not found or unauthorized'),
    );

    _experiences.remove(experience);
  }

  // Update an experience
  Future<Experience> updateExperience({
    required String experienceId,
    required String userId,
    String? title,
    String? description,
    List<ExperienceMedia>? newMedia,
    List<String>? locations,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    Itinerary? itinerary,
    bool? isPublic,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final experience = _experiences.firstWhere(
      (e) => e.id == experienceId && e.userId == userId,
      orElse: () => throw Exception('Experience not found or unauthorized'),
    );
    final index = _experiences.indexOf(experience);

    // In a real app, this would:
    // 1. Upload any new media files
    // 2. Update experience in backend
    // 3. Return updated experience

    _experiences[index] = Experience(
      id: experience.id,
      userId: experience.userId,
      userName: experience.userName,
      userAvatar: experience.userAvatar,
      title: title ?? experience.title,
      description: description ?? experience.description,
      media: newMedia ?? experience.media,
      locations: locations ?? experience.locations,
      startDate: startDate ?? experience.startDate,
      endDate: endDate ?? experience.endDate,
      tags: tags ?? experience.tags,
      itinerary: itinerary ?? experience.itinerary,
      likes: experience.likes,
      dislikes: experience.dislikes,
      isPublic: isPublic ?? experience.isPublic,
      createdAt: experience.createdAt,
      updatedAt: DateTime.now(),
    );

    return _experiences[index];
  }
} 