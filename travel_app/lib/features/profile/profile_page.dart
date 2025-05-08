import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../models/itinerary.dart';
import '../../models/gang.dart';
import '../../models/travel_preferences.dart';
import '../../models/user_level.dart';
import '../../services/gang_service.dart';
import '../../services/gamification_service.dart';
import '../../services/auth_service.dart';
import '../gang/gang_edit_dialog.dart';
import '../gang/gang_invite_dialog.dart';
import '../gang/travel_preferences_editor.dart';
import '../onboarding/onboarding_page.dart';
import 'preferences_editor.dart';
import 'preferences_viewer.dart';
import 'level_progression_card.dart';
import 'achievements_page.dart';

class ProfileEditDialog extends StatefulWidget {
  final Map<String, dynamic> userData;
  
  const ProfileEditDialog({required this.userData, super.key});
  
  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _avatarController;
  late TextEditingController _ageController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _locationController = TextEditingController(text: widget.userData['location']);
    _bioController = TextEditingController(text: widget.userData['bio']);
    _avatarController = TextEditingController(text: widget.userData['avatar']);
    _ageController = TextEditingController(text: '25'); // Default age
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF23243B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.person, color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.cake, color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.location_on, color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.edit, color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _avatarController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Profile Picture URL',
                labelStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.image, color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final updatedData = Map<String, dynamic>.from(widget.userData);
                    updatedData['name'] = _nameController.text.trim();
                    updatedData['location'] = _locationController.text.trim();
                    updatedData['bio'] = _bioController.text.trim();
                    updatedData['avatar'] = _avatarController.text.trim();
                    Navigator.pop(context, updatedData);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserId = '123';
  final GangService _gangService = GangService();
  final GamificationService _gamificationService = GamificationService();
  bool _isLoadingGangs = true;
  bool _isLoadingLevel = true;
  List<Gang> _myGangs = [];
  List<GangInvitation> _pendingInvitations = [];
  late TravelPreferences _preferences;
  
  // Level data
  late UserLevel _currentLevel;
  late UserLevel _nextLevel;
  late double _progress;
  int _totalPoints = 0;

  // Dummy user data
  Map<String, dynamic> userData = {
    'id': '123',
    'name': 'Aditi Sharma',
    'email': 'aditi.sharma@example.com',
    'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    'location': 'Mumbai, India',
    'bio': 'Adventure seeker | Photography enthusiast | Travel blogger',
    'totalTrips': 12,
    'countries': 5,
    'followers': 1240,
    'following': 890,
    'totalSpent': 245000,
  };

  @override
  void initState() {
    super.initState();
    _loadGangsAndInvitations();
    _loadUserLevel();
    // Initialize with default preferences - in a real app, this would come from a user service
    _preferences = TravelPreferences.defaultPreferences();
    
    // Update userData with auth info if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.isLoggedIn && authService.userId != null) {
        setState(() {
          userData['id'] = authService.userId;
          if (authService.userName != null) userData['name'] = authService.userName;
          if (authService.userEmail != null) userData['email'] = authService.userEmail;
          if (authService.userAvatar != null) userData['avatar'] = authService.userAvatar;
        });
      }
    });
  }

  Future<void> _loadUserLevel() async {
    setState(() => _isLoadingLevel = true);
    try {
      final currentLevel = await _gamificationService.getUserLevel();
      final nextLevel = await _gamificationService.getNextLevel();
      final progress = await _gamificationService.getProgressToNextLevel();
      final points = await _gamificationService.getUserPoints();
      
      if (!mounted) return;
      
      setState(() {
        _currentLevel = currentLevel;
        _nextLevel = nextLevel;
        _progress = progress;
        _totalPoints = points;
        _isLoadingLevel = false;
      });
    } catch (e) {
      debugPrint('Error loading level: $e');
      if (!mounted) return;
      
      setState(() => _isLoadingLevel = false);
    }
  }

  Future<void> _loadGangsAndInvitations() async {
    if (!mounted) return;
    
    setState(() => _isLoadingGangs = true);
    try {
      final gangs = await _gangService.getUserGangs(currentUserId);
      final invitations = await _gangService.getPendingInvitations(userData['email'] ?? '');
      
      if (!mounted) return;
      
      setState(() {
        _myGangs = gangs;
        _pendingInvitations = invitations;
        _isLoadingGangs = false;
      });
    } catch (e) {
      debugPrint('Error loading gangs: $e');
      if (!mounted) return;
      
      setState(() => _isLoadingGangs = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load gangs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createGang() async {
    final result = await showDialog<Gang>(
      context: context,
      builder: (context) => const GangEditDialog(),
    );
    if (result != null) {
      await _gangService.saveGang(currentUserId, result);
      _loadGangsAndInvitations();
    }
  }

  void _editGang(Gang gang) async {
    final result = await showDialog<Gang>(
      context: context,
      builder: (context) => GangEditDialog(existing: gang),
    );
    if (result != null) {
      await _gangService.saveGang(currentUserId, result);
      _loadGangsAndInvitations();
    }
  }

  void _inviteToGang(Gang gang) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => GangInviteDialog(
        gangId: gang.id,
        gangName: gang.name,
        inviterName: userData['name'],
      ),
    );
    
    if (result == true) {
      _loadGangsAndInvitations();
    }
  }

  void _editPreferences() async {
    final result = await Navigator.push<TravelPreferences>(
      context,
      MaterialPageRoute(
        builder: (context) => PreferencesEditor(
          initialPreferences: _preferences,
          onSave: (newPreferences) {
            setState(() {
              _preferences = newPreferences;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _preferences = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: userData['avatar'] != null 
                          ? NetworkImage(userData['avatar'])
                          : null,
                      child: userData['avatar'] == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? 'Anonymous User',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userData['email'] ?? 'No email provided',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          if (!_isLoadingLevel)
                            Chip(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              label: Text(
                                _currentLevel.title,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              avatar: Icon(
                                Icons.psychology,
                                color: Theme.of(context).colorScheme.primary,
                                size: 10,
                              ),
                              labelPadding: EdgeInsets.zero,
                              padding: const EdgeInsets.all(2),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('Trips', (userData['totalTrips'] ?? 0).toString()),
                    _buildStat('Countries', (userData['countries'] ?? 0).toString()),
                    _buildStat('Followers', (userData['followers'] ?? 0).toString()),
                    _buildStat('Points', _totalPoints.toString()),
                  ],
                ),
              ),

              // Level Progression
              if (_isLoadingLevel)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                LevelProgressionCard(
                  currentLevel: _currentLevel,
                  nextLevel: _nextLevel,
                  progress: _progress,
                  totalPoints: _totalPoints,
                ),

              const Divider(height: 32),

              // Travel Gangs Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Travel Gangs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _createGang,
                      icon: const Icon(Icons.add),
                      label: const Text('Create Gang'),
                    ),
                  ],
                ),
              ),

              if (_isLoadingGangs)
                const Center(child: CircularProgressIndicator())
              else ...[
                // Pending Invitations
                if (_pendingInvitations.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Pending Invitations',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _pendingInvitations.length,
                            itemBuilder: (context, index) {
                              final invitation = _pendingInvitations[index];
                              return ListTile(
                                title: Text(invitation.gangName),
                                subtitle: Text('From: ${invitation.inviterName}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () => _handleInvitation(invitation, true),
                                      child: const Text('Accept'),
                                    ),
                                    TextButton(
                                      onPressed: () => _handleInvitation(invitation, false),
                                      child: const Text('Decline'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                // My Gangs
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: _myGangs.length,
                  itemBuilder: (context, index) {
                    final gang = _myGangs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              gang.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('${gang.members.length} members'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.person_add),
                                  onPressed: () => _inviteToGang(gang),
                                  tooltip: 'Invite Member',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editGang(gang),
                                  tooltip: 'Edit Gang',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Members',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: gang.members.map((member) {
                                    return Chip(
                                      avatar: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          member.avatarUrl ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(member.name)}&background=random'
                                        ),
                                      ),
                                      label: Text(member.name),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],

              const Divider(height: 32),

              // Travel Preferences Section
              PreferencesViewer(
                preferences: _preferences,
                isEditable: true,
                onEdit: _editPreferences,
              ),

              // Menu Items
              _buildMenuItem(
                context,
                icon: Icons.emoji_events_outlined,
                title: 'View Achievements',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AchievementsPage(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.map_outlined,
                title: 'My Trips',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => _handleLogout(context),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.white,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Future<void> _handleInvitation(GangInvitation invitation, bool accept) async {
    try {
      if (accept) {
        await _gangService.acceptInvitation(invitation.id, userData['email']);
      } else {
        await _gangService.declineInvitation(invitation.id, userData['email']);
      }
      _loadGangsAndInvitations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${accept ? 'accept' : 'decline'} invitation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logout();
      
      if (!mounted) return;
      
      // Navigate to onboarding page after logout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
        (route) => false, // Remove all previous routes
      );
    }
  }
} 