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
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_logo.dart';
import '../../core/widgets/branded_app_bar.dart';
import '../gang/gang_edit_dialog.dart';
import '../gang/gang_invite_dialog.dart';
import '../gang/travel_preferences_editor.dart';
import '../onboarding/onboarding_page.dart';
import 'preferences_editor.dart';
import 'preferences_viewer.dart';
import 'level_progression_card.dart';
import 'achievements_page.dart';
import '../../core/widgets/global_app_bar.dart';

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
    'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
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
    _preferences = TravelPreferences.defaultPreferences();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.isLoggedIn) {
        setState(() {
          userData['email'] = authService.userEmail;
          if (authService.userName != null) {
            userData['name'] = authService.userName;
          }
          if (authService.userAvatar != null) {
            userData['avatar'] = authService.userAvatar;
          }
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

  void _showThemeSelector(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Theme Preference',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...ThemePreference.values.map((preference) {
              final isSelected = themeProvider.themePreference == preference;
              final title = switch (preference) {
                ThemePreference.system => 'System',
                ThemePreference.light => 'Light',
                ThemePreference.dark => 'Dark',
              };
              final icon = switch (preference) {
                ThemePreference.system => Icons.settings_suggest_outlined,
                ThemePreference.light => Icons.light_mode_outlined,
                ThemePreference.dark => Icons.dark_mode_outlined,
              };
              
              return ListTile(
                leading: Icon(
                  icon,
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  themeProvider.setThemePreference(preference);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: _isLoadingLevel || _isLoadingGangs
        ? Center(
            child: SpinKitPulse(
              color: theme.colorScheme.primary,
              size: 50.0,
            ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              await _loadGangsAndInvitations();
              await _loadUserLevel();
            },
            child: CustomScrollView(
              slivers: [
                // Profile Header
                SliverToBoxAdapter(
                  child: _buildProfileHeader(theme),
                ),
                // Rest of the content...
                SliverToBoxAdapter(
                  child: _buildStatsRow(theme),
                ),
                SliverToBoxAdapter(
                  child: _buildLevelProgressionCard(),
                ),
                SliverToBoxAdapter(
                  child: _buildPreferencesSection(),
                ),
                SliverToBoxAdapter(
                  child: _buildGangsSection(),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: kBottomNavigationBarHeight + 16),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(userData['avatar'] as String),
          ),
          const SizedBox(height: 16),
          Text(
            userData['name'] as String,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userData['location'] as String,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userData['bio'] as String,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _editProfile,
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Trips', userData['totalTrips'].toString()),
          _buildStatItem('Countries', userData['countries'].toString()),
          _buildStatItem('Followers', userData['followers'].toString()),
          _buildStatItem('Following', userData['following'].toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelProgressionCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LevelProgressionCard(
        currentLevel: _currentLevel,
        nextLevel: _nextLevel,
        progress: _progress,
        totalPoints: _totalPoints,
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travel Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          PreferencesViewer(preferences: _preferences),
        ],
      ),
    );
  }

  Widget _buildGangsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Gangs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _myGangs.length,
            itemBuilder: (context, index) {
              final gang = _myGangs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(gang.avatar),
                ),
                title: Text(gang.name),
                subtitle: Text('${gang.members.length} members'),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showGangOptions(gang),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _editProfile() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ProfileEditDialog(userData: userData),
    );
    
    if (result != null) {
      setState(() {
        userData = result;
      });
    }
  }

  void _showGangOptions(Gang gang) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Gang'),
            onTap: () {
              Navigator.pop(context);
              _editGang(gang);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Invite Members'),
            onTap: () {
              Navigator.pop(context);
              _inviteToGang(gang);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Leave Gang'),
            onTap: () {
              Navigator.pop(context);
              _leaveGang(gang);
            },
          ),
        ],
      ),
    );
  }

  void _leaveGang(Gang gang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Gang'),
        content: Text('Are you sure you want to leave ${gang.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement leave gang functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Left gang successfully'),
                ),
              );
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
} 