import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/itinerary.dart';

class ChatService {
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();
  final Map<String, List<ChatMessage>> _tripMessages = {};
  final Map<String, List<String>> _tripMembers = {};
  
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  void initializeTrip(Itinerary trip) {
    if (!_tripMessages.containsKey(trip.id)) {
      _tripMessages[trip.id] = [];
      _tripMembers[trip.id] = ['You']; // Initialize with the current user
      
      // Add system welcome message
      _addSystemMessage(
        tripId: trip.id,
        content: 'Welcome to ${trip.destination} Gang Hangout! 🎉\nShare updates, coordinate meetups, and have a great trip!',
      );
      
      // Add trip info message
      _addSystemMessage(
        tripId: trip.id,
        content: 'Trip Details:\n'
          '📍 ${trip.destination}\n'
          '📅 ${trip.startDate.toString().split(' ')[0]} - ${trip.endDate.toString().split(' ')[0]}\n'
          '👥 ${trip.numberOfPeople} people',
        type: MessageType.text,
        metadata: {
          'tripId': trip.id,
          'destination': trip.destination,
          'startDate': trip.startDate.toIso8601String(),
          'endDate': trip.endDate.toIso8601String(),
        },
      );
    }
  }

  void addMember(String tripId, String memberName) {
    if (_tripMembers.containsKey(tripId) && !_tripMembers[tripId]!.contains(memberName)) {
      _tripMembers[tripId]!.add(memberName);
      _addSystemMessage(
        tripId: tripId,
        content: '$memberName joined the gang! 👋',
      );
    }
  }

  void sendMessage({
    required String tripId,
    required String senderId,
    required String senderName,
    required String content,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  }) {
    if (!_tripMessages.containsKey(tripId)) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      senderName: senderName,
      timestamp: DateTime.now(),
      type: type,
      content: content,
      metadata: metadata,
    );

    _tripMessages[tripId]!.add(message);
    _notifyListeners(tripId);
  }

  void _addSystemMessage({
    required String tripId,
    required String content,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  }) {
    if (!_tripMessages.containsKey(tripId)) return;

    final message = ChatMessage.system(
      content: content,
      type: type,
      metadata: metadata,
    );

    _tripMessages[tripId]!.add(message);
    _notifyListeners(tripId);
  }

  void setReminder({
    required String tripId,
    required String title,
    required DateTime dateTime,
    String? description,
  }) {
    _addSystemMessage(
      tripId: tripId,
      content: '⏰ Reminder set: $title\n${description ?? ''}\nTime: ${dateTime.toString().split('.')[0]}',
      type: MessageType.reminder,
      metadata: {
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'description': description,
      },
    );
  }

  void shareLocation({
    required String tripId,
    required String senderId,
    required String senderName,
    required double latitude,
    required double longitude,
    String? description,
  }) {
    sendMessage(
      tripId: tripId,
      senderId: senderId,
      senderName: senderName,
      content: description ?? 'Shared current location',
      type: MessageType.location,
      metadata: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }

  void shareDocument({
    required String tripId,
    required String senderId,
    required String senderName,
    required String fileName,
    required String fileUrl,
    required String fileType,
  }) {
    sendMessage(
      tripId: tripId,
      senderId: senderId,
      senderName: senderName,
      content: 'Shared document: $fileName',
      type: MessageType.document,
      metadata: {
        'fileName': fileName,
        'fileUrl': fileUrl,
        'fileType': fileType,
      },
    );
  }

  void addWellbeingTip({
    required String tripId,
    required String tip,
    required String category,
  }) {
    _addSystemMessage(
      tripId: tripId,
      content: '💪 Wellbeing Tip: $tip',
      type: MessageType.wellbeing,
      metadata: {
        'tip': tip,
        'category': category,
      },
    );
  }

  void addHygieneTip({
    required String tripId,
    required String tip,
  }) {
    _addSystemMessage(
      tripId: tripId,
      content: '🧼 Hygiene Tip: $tip',
      type: MessageType.hygiene,
      metadata: {
        'tip': tip,
      },
    );
  }

  void updateChecklist({
    required String tripId,
    required List<String> items,
    required List<bool> checked,
  }) {
    _addSystemMessage(
      tripId: tripId,
      content: '📝 Trip Checklist Updated',
      type: MessageType.checklist,
      metadata: {
        'items': items,
        'checked': checked,
      },
    );
  }

  List<ChatMessage> getMessages(String tripId) {
    return _tripMessages[tripId] ?? [];
  }

  List<String> getMembers(String tripId) {
    return _tripMembers[tripId] ?? [];
  }

  void _notifyListeners(String tripId) {
    _messagesController.add(_tripMessages[tripId] ?? []);
  }

  void dispose() {
    _messagesController.close();
  }
} 