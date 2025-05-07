import 'package:flutter/material.dart';
import '../../models/gang.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Gang> gangs = [
    Gang(
      id: '1',
      name: 'The Adventurers',
      members: [
        GangMember(name: 'Aditi Sharma', age: 27, gender: 'Female', email: 'aditi@email.com', phone: '1234567890', avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg'),
        GangMember(name: 'Rahul Verma', age: 29, gender: 'Male', email: 'rahul@email.com', phone: '9876543210', avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg'),
      ],
    ),
    Gang(
      id: '2',
      name: 'Foodies',
      members: [
        GangMember(name: 'Priya Singh', age: 25, gender: 'Female', email: 'priya@email.com', phone: '5551234567', avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg'),
      ],
    ),
  ];

  void _addGang() async {
    final newGang = await showDialog<Gang>(
      context: context,
      builder: (ctx) => GangEditDialog(),
    );
    if (newGang != null) {
      setState(() => gangs.add(newGang));
    }
  }

  void _editGang(int idx) async {
    final editedGang = await showDialog<Gang>(
      context: context,
      builder: (ctx) => GangEditDialog(existing: gangs[idx]),
    );
    if (editedGang != null) {
      setState(() => gangs[idx] = editedGang);
    }
  }

  void _deleteGang(int idx) {
    setState(() => gangs.removeAt(idx));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.group_add),
                  tooltip: 'Create New Gang',
                  onPressed: _addGang,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('My Gangs', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...gangs.asMap().entries.map((entry) {
              final idx = entry.key;
              final gang = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(gang.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    ...gang.members.map((m) => ListTile(
                          leading: m.avatarUrl != null ? CircleAvatar(backgroundImage: NetworkImage(m.avatarUrl!)) : const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(m.name),
                          subtitle: Text('Age: ${m.age}, Gender: ${m.gender}${m.email != null ? '\nEmail: ${m.email}' : ''}${m.phone != null ? '\nPhone: ${m.phone}' : ''}'),
                        )),
                    ButtonBar(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          onPressed: () => _editGang(idx),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          onPressed: () => _deleteGang(idx),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class GangEditDialog extends StatefulWidget {
  final Gang? existing;
  const GangEditDialog({this.existing, super.key});

  @override
  State<GangEditDialog> createState() => _GangEditDialogState();
}

class _GangEditDialogState extends State<GangEditDialog> {
  late TextEditingController _nameController;
  List<GangMember> members = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    members = widget.existing?.members.map((m) => GangMember(
      name: m.name,
      age: m.age,
      gender: m.gender,
      email: m.email,
      phone: m.phone,
      avatarUrl: m.avatarUrl,
    )).toList() ?? [];
  }

  void _addMember() async {
    final newMember = await showDialog<GangMember>(
      context: context,
      builder: (ctx) => GangMemberEditDialog(),
    );
    if (newMember != null) {
      setState(() => members.add(newMember));
    }
  }

  void _editMember(int idx) async {
    final edited = await showDialog<GangMember>(
      context: context,
      builder: (ctx) => GangMemberEditDialog(existing: members[idx]),
    );
    if (edited != null) {
      setState(() => members[idx] = edited);
    }
  }

  void _deleteMember(int idx) {
    setState(() => members.removeAt(idx));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Create Gang' : 'Edit Gang'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Gang Name'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Members', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  tooltip: 'Add Member',
                  onPressed: _addMember,
                ),
              ],
            ),
            ...members.asMap().entries.map((entry) {
              final idx = entry.key;
              final m = entry.value;
              return ListTile(
                leading: m.avatarUrl != null ? CircleAvatar(backgroundImage: NetworkImage(m.avatarUrl!)) : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(m.name),
                subtitle: Text('Age: ${m.age}, Gender: ${m.gender}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _editMember(idx)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteMember(idx)),
                  ],
                ),
              );
            }),
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
            if (_nameController.text.trim().isEmpty || members.isEmpty) return;
            Navigator.pop(context, Gang(
              id: widget.existing?.id ?? Random().nextInt(100000).toString(),
              name: _nameController.text.trim(),
              members: members,
            ));
          },
          child: Text(widget.existing == null ? 'Create' : 'Save'),
        ),
      ],
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
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _ageController = TextEditingController(text: widget.existing?.age.toString() ?? '');
    _genderController = TextEditingController(text: widget.existing?.gender ?? '');
    _emailController = TextEditingController(text: widget.existing?.email ?? '');
    _phoneController = TextEditingController(text: widget.existing?.phone ?? '');
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
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
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
            if (_nameController.text.trim().isEmpty || _ageController.text.trim().isEmpty || _genderController.text.trim().isEmpty) return;
            Navigator.pop(context, GangMember(
              name: _nameController.text.trim(),
              age: int.tryParse(_ageController.text.trim()) ?? 0,
              gender: _genderController.text.trim(),
              email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
              phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
              avatarUrl: _avatarController.text.trim().isEmpty ? null : _avatarController.text.trim(),
            ));
          },
          child: Text(widget.existing == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
} 