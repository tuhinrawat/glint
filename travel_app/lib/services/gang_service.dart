import 'package:flutter/material.dart';
import '../models/gang.dart';
import '../models/travel_preferences.dart';

class GangService {
  // Singleton instance
  static final GangService _instance = GangService._internal();
  factory GangService() => _instance;
  GangService._internal() {
    // Initialize with test data
    final testGang = Gang(
      id: 'gang1',
      name: 'Adventure Squad',
      description: 'A group of adventurous travelers exploring the world together',
      members: [
        GangMember(
          id: '123',
          name: 'Aditi Sharma',
          email: 'aditi.sharma@example.com',
          avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
          preferences: TravelPreferences.defaultPreferences(),
        ),
        GangMember(
          id: 'member2',
          name: 'John Doe',
          email: 'john.doe@example.com',
          avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
          preferences: TravelPreferences.defaultPreferences(),
        ),
      ],
      createdAt: DateTime.now(),
      createdBy: '123',
      groupPreferences: TravelPreferences.defaultPreferences(),
    );

    final testInvitation = GangInvitation(
      id: 'inv1',
      gangId: 'gang1',
      gangName: 'Adventure Squad',
      inviterName: 'Aditi Sharma',
      inviteeEmail: 'aditi.sharma@example.com',
      timestamp: DateTime.now(),
    );

    // Add test data to storage
    _userGangs['123'] = [testGang];
    _pendingInvitations['aditi.sharma@example.com'] = [testInvitation];
  }

  // In-memory storage (replace with backend in production)
  final Map<String, List<Gang>> _userGangs = {};
  final Map<String, List<GangInvitation>> _pendingInvitations = {};

  // Send invitation to join a gang
  Future<void> inviteToGang({
    required String gangId,
    required String gangName,
    required String inviterName,
    required String inviteeEmail,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Create invitation
    final invitation = GangInvitation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gangId: gangId,
      gangName: gangName,
      inviterName: inviterName,
      inviteeEmail: inviteeEmail,
      timestamp: DateTime.now(),
    );

    // Store invitation
    if (!_pendingInvitations.containsKey(inviteeEmail)) {
      _pendingInvitations[inviteeEmail] = [];
    }
    _pendingInvitations[inviteeEmail]!.add(invitation);

    // In a real app, this would:
    // 1. Send email with app download link if user doesn't exist
    // 2. Send push notification if user has the app
    // 3. Store invitation in backend
    debugPrint('Invitation sent to $inviteeEmail for gang $gangName');
  }

  // Accept gang invitation
  Future<void> acceptInvitation(String invitationId, String userEmail) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final invitations = _pendingInvitations[userEmail] ?? [];
    final invitationIndex = invitations.indexWhere((inv) => inv.id == invitationId);

    if (invitationIndex != -1) {
      final invitation = invitations[invitationIndex];
      
      // Add user to gang (in real app, this would update backend)
      final gang = await getGangById(invitation.gangId);
      if (gang != null) {
        gang.members.add(GangMember(
          id: userEmail, // Using email as ID for simplicity
          name: 'New Member', // In real app, get from user profile
          email: userEmail,
          avatarUrl: 'https://ui-avatars.com/api/?name=New+Member',
          preferences: TravelPreferences.defaultPreferences(),
        ));
      }

      // Remove invitation
      invitations.removeAt(invitationIndex);
    }
  }

  // Decline gang invitation
  Future<void> declineInvitation(String invitationId, String userEmail) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final invitations = _pendingInvitations[userEmail] ?? [];
    _pendingInvitations[userEmail] = invitations.where((inv) => inv.id != invitationId).toList();
  }

  // Get pending invitations for a user
  Future<List<GangInvitation>> getPendingInvitations(String userEmail) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _pendingInvitations[userEmail] ?? [];
  }

  // Get gang by ID
  Future<Gang?> getGangById(String gangId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (final gangs in _userGangs.values) {
      final gang = gangs.firstWhere((g) => g.id == gangId, orElse: () => Gang(
        id: '',
        name: '',
        description: 'Empty gang',
        members: [],
        createdAt: DateTime.now(),
        createdBy: '',
        groupPreferences: TravelPreferences.defaultPreferences(),
      ));
      if (gang.id.isNotEmpty) return gang;
    }
    return null;
  }

  // Get all gangs for a user
  Future<List<Gang>> getUserGangs(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _userGangs[userId] ?? [];
  }

  // Create or update a gang
  Future<void> saveGang(String userId, Gang gang) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!_userGangs.containsKey(userId)) {
      _userGangs[userId] = [];
    }

    final index = _userGangs[userId]!.indexWhere((g) => g.id == gang.id);
    if (index != -1) {
      _userGangs[userId]![index] = gang;
    } else {
      _userGangs[userId]!.add(gang);
    }
  }
}

class GangInvitation {
  final String id;
  final String gangId;
  final String gangName;
  final String inviterName;
  final String inviteeEmail;
  final DateTime timestamp;

  GangInvitation({
    required this.id,
    required this.gangId,
    required this.gangName,
    required this.inviterName,
    required this.inviteeEmail,
    required this.timestamp,
  });
} 