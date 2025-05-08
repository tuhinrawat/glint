import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/gang.dart';
import '../../models/travel_preferences.dart';
import 'travel_preferences_editor.dart';

class GangEditDialog extends StatefulWidget {
  final Gang? existing;
  const GangEditDialog({this.existing, super.key});

  @override
  State<GangEditDialog> createState() => _GangEditDialogState();
}

class _GangEditDialogState extends State<GangEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  List<GangMember> members = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _descriptionController = TextEditingController(text: widget.existing?.description ?? '');
    members = List<GangMember>.from(widget.existing?.members.map((m) => GangMember(
      id: m.id,
      name: m.name,
      email: m.email,
      avatarUrl: m.avatarUrl,
      preferences: m.preferences,
    )) ?? []);
  }

  void _addMember() async {
    final result = await showDialog<GangMember>(
      context: context,
      builder: (ctx) => const GangMemberEditDialog(),
    );
    if (result != null) {
      setState(() => members.add(result));
    }
  }

  void _editMember(int idx) async {
    final result = await showDialog<GangMember>(
      context: context,
      builder: (ctx) => GangMemberEditDialog(existing: members[idx]),
    );
    if (result != null) {
      setState(() => members[idx] = result);
    }
  }

  void _editMemberPreferences(int idx) async {
    final result = await Navigator.push<TravelPreferences>(
      context,
      MaterialPageRoute(
        builder: (context) => TravelPreferencesEditor(
          initialPreferences: members[idx].preferences,
          onSave: (newPreferences) {
            setState(() {
              members[idx] = GangMember(
                id: members[idx].id,
                name: members[idx].name,
                email: members[idx].email,
                avatarUrl: members[idx].avatarUrl,
                preferences: newPreferences,
              );
            });
            Navigator.pop(context, newPreferences);
          },
        ),
      ),
    );
  }

  void _deleteMember(int idx) {
    setState(() => members.removeAt(idx));
  }

  @override
  Widget build(BuildContext context) {
    final gang = widget.existing != null ? Gang(
      id: widget.existing!.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      members: members,
      createdAt: widget.existing!.createdAt,
      createdBy: widget.existing!.createdBy,
      groupPreferences: Gang.calculateGroupPreferences(members),
    ) : null;
    
    final groupPrefs = gang?.groupPreferences;

    return Dialog(
      backgroundColor: const Color(0xFF23243B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                    widget.existing == null ? 'Create Gang' : 'Edit Gang',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Gang Name',
                      labelStyle: TextStyle(color: Colors.grey[400]),
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
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.grey[400]),
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
                ],
              ),
            ),
            
            // Members List
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Members',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.person_add_rounded, color: Colors.white),
                          tooltip: 'Add Member',
                          onPressed: _addMember,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...members.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final m = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: Colors.white.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Large Avatar
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                      child: m.avatarUrl != null && m.avatarUrl!.isNotEmpty
                                          ? ClipOval(
                                              child: Image.network(
                                                m.avatarUrl!,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Text(
                                              m.name.substring(0, min(2, m.name.length)).toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Member Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          m.email,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        // Action Icons
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.settings_rounded, color: Colors.white70, size: 20),
                                              tooltip: 'Edit Preferences',
                                              onPressed: () => _editMemberPreferences(idx),
                                              padding: const EdgeInsets.all(8),
                                              constraints: const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 4),
                                            IconButton(
                                              icon: const Icon(Icons.edit_rounded, color: Colors.white70, size: 20),
                                              tooltip: 'Edit Details',
                                              onPressed: () => _editMember(idx),
                                              padding: const EdgeInsets.all(8),
                                              constraints: const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 4),
                                            IconButton(
                                              icon: Icon(Icons.delete_rounded, color: Colors.red[300], size: 20),
                                              tooltip: 'Remove Member',
                                              onPressed: () => _deleteMember(idx),
                                              padding: const EdgeInsets.all(8),
                                              constraints: const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: Colors.white24),
                              const SizedBox(height: 8),
                              Text(
                                'Travel Preferences',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildPreferenceChip(
                                      icon: Icons.account_balance_wallet,
                                      label: m.preferences.budgetPreference.toString().split('.').last,
                                    ),
                                    const SizedBox(width: 8),
                                    ...m.preferences.travelStyles.take(2).map((style) =>
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: _buildPreferenceChip(
                                          icon: Icons.style,
                                          label: style,
                                        ),
                                      ),
                                    ),
                                    ...m.preferences.activities.take(2).map((activity) =>
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: _buildPreferenceChip(
                                          icon: Icons.local_activity,
                                          label: activity,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
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
                      if (_nameController.text.trim().isEmpty || members.isEmpty) return;
                      Navigator.pop(context, Gang(
                        id: widget.existing?.id ?? Random().nextInt(100000).toString(),
                        name: _nameController.text.trim(),
                        description: _descriptionController.text.trim(),
                        members: members,
                        createdAt: DateTime.now(),
                        createdBy: members.first.id,
                        groupPreferences: Gang.calculateGroupPreferences(members),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(widget.existing == null ? 'Create' : 'Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class GangMemberEditDialog extends StatefulWidget {
  final GangMember? existing;
  const GangMemberEditDialog({this.existing, super.key});

  @override
  State<GangMemberEditDialog> createState() => _GangMemberEditDialogState();
}

class _GangMemberEditDialogState extends State<GangMemberEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _emailController = TextEditingController(text: widget.existing?.email ?? '');
    _avatarController = TextEditingController(text: widget.existing?.avatarUrl ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Member' : 'Edit Member'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _avatarController,
              decoration: const InputDecoration(labelText: 'Avatar URL'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.trim().isEmpty) return;
            
            // Generate a unique ID for new members or use existing ID
            final memberId = widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
            
            Navigator.pop(context, GangMember(
              id: memberId,
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              avatarUrl: _avatarController.text.trim().isEmpty ? null : _avatarController.text.trim(),
              preferences: widget.existing?.preferences ?? TravelPreferences.defaultPreferences(),
            ));
          },
          child: Text(widget.existing == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}