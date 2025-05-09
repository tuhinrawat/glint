import 'package:flutter/material.dart';

enum MessageType {
  text,
  image,
  document,
  reminder,
  checklist,
  wellbeing,
  hygiene,
  location
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final DateTime timestamp;
  final MessageType type;
  final String content;
  final Map<String, dynamic>? metadata;
  final bool isSystem;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.timestamp,
    required this.type,
    required this.content,
    this.metadata,
    this.isSystem = false,
  });

  factory ChatMessage.system({
    required String content,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'system',
      senderName: 'System',
      timestamp: DateTime.now(),
      type: type,
      content: content,
      metadata: metadata,
      isSystem: true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'senderAvatar': senderAvatar,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
    'content': content,
    'metadata': metadata,
    'isSystem': isSystem,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String,
    senderId: json['senderId'] as String,
    senderName: json['senderName'] as String,
    senderAvatar: json['senderAvatar'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
    type: MessageType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => MessageType.text,
    ),
    content: json['content'] as String,
    metadata: json['metadata'] as Map<String, dynamic>?,
    isSystem: json['isSystem'] as bool? ?? false,
  );
} 