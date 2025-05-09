import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../models/chat_message.dart';
import '../../models/gang_document.dart';
import '../../models/gang_reminder.dart';
import '../../models/gang_checklist.dart';
import '../../models/gang_wellbeing.dart';
import '../../models/gang_hygiene.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_styles.dart';
import '../../services/chat_service.dart';
import '../../core/widgets/global_app_bar.dart';
import 'package:intl/intl.dart';
import '../../services/gang_hangout_service.dart';

class GangHangoutPage extends StatefulWidget {
  final Itinerary? activeTrip;
  
  const GangHangoutPage({
    super.key,
    this.activeTrip,
  });

  @override
  State<GangHangoutPage> createState() => _GangHangoutPageState();
}

class _GangHangoutPageState extends State<GangHangoutPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final GangHangoutService _gangHangoutService = GangHangoutService();
  bool _showPlugins = false;
  List<ChatMessage> _messages = [];
  
  // Plugin data
  List<GangDocument> _pinnedDocuments = [];
  List<GangReminder> _pinnedReminders = [];
  GangChecklist? _activeChecklist;
  List<GangWellbeing> _wellbeingChecks = [];
  List<GangHygiene> _hygieneChecks = [];

  bool get _canCloseTrip => widget.activeTrip != null && 
      _gangHangoutService.canCloseTrip(widget.activeTrip!);
  
  @override
  void initState() {
    super.initState();
    if (widget.activeTrip != null) {
      _chatService.initializeTrip(widget.activeTrip!);
      _messages = _chatService.getMessages(widget.activeTrip!.id);
      _chatService.messagesStream.listen((messages) {
        setState(() {
          _messages = messages;
        });
      });
      _loadPluginData();
      _checkTripStatus();
    }
  }

  void _checkTripStatus() {
    if (widget.activeTrip == null) return;

    if (widget.activeTrip!.isCompleted && !_canCloseTrip) {
      // Show completion message but not yet closeable
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Trip completed! Gang Hangout will be available for 3 more days.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } else if (_canCloseTrip) {
      // Show closure available message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You can now close this trip and archive the Gang Hangout.',
          ),
          action: SnackBarAction(
            label: 'Close Trip',
            onPressed: _showTripClosureDialog,
          ),
          duration: Duration(seconds: 10),
        ),
      );
    }
  }

  void _showTripClosureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Close Trip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to close this trip?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'This will:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('• Archive all chat messages'),
            Text('• Archive all documents and reminders'),
            Text('• Archive all checklists and status updates'),
            Text('• Reset the Gang Hangout for future trips'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _closeTrip();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Close Trip'),
          ),
        ],
      ),
    );
  }

  Future<void> _closeTrip() async {
    if (widget.activeTrip == null) return;

    try {
      final success = await _gangHangoutService.requestTripClosure(
        widget.activeTrip!.id,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip closed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Return to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to close trip. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error closing trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadPluginData() async {
    // TODO: Load data from services
    setState(() {
      _pinnedDocuments = [
        GangDocument(
          id: '1',
          name: 'Flight Tickets.pdf',
          url: 'https://example.com/tickets.pdf',
          uploadedBy: 'John',
          uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
          type: 'pdf',
          isPinned: true,
        ),
      ];
      
      _pinnedReminders = [
        GangReminder(
          id: '1',
          title: 'Pack Sunscreen',
          description: 'Don\'t forget to pack sunscreen, it\'s going to be sunny!',
          reminderTime: DateTime.now().add(const Duration(days: 1)),
          createdBy: 'Sarah',
          createdAt: DateTime.now(),
          isPinned: true,
        ),
      ];
      
      _activeChecklist = GangChecklist(
        id: '1',
        title: 'Pre-Trip Checklist',
        items: [
          ChecklistItem(
            id: '1',
            title: 'Passport',
            category: ChecklistCategory.documents,
          ),
          ChecklistItem(
            id: '2',
            title: 'Travel Insurance',
            category: ChecklistCategory.documents,
          ),
        ],
        memberCompletions: {
          'user1': ['1'],
          'user2': ['1', '2'],
        },
        createdAt: DateTime.now(),
        createdBy: 'Admin',
      );
    });
  }

  void _showDocuments() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documents',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _pinnedDocuments.length,
                itemBuilder: (context, index) {
                  final doc = _pinnedDocuments[index];
                  return ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(doc.name),
                    subtitle: Text('Uploaded by ${doc.uploadedBy}'),
                    trailing: IconButton(
                      icon: Icon(
                        doc.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      ),
                      onPressed: () {
                        // TODO: Toggle pin status
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement document upload
                },
                child: const Text('Upload Document'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminders() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminders',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _pinnedReminders.length,
                itemBuilder: (context, index) {
                  final reminder = _pinnedReminders[index];
                  return ListTile(
                    leading: const Icon(Icons.alarm),
                    title: Text(reminder.title),
                    subtitle: Text(
                      '${reminder.description}\nDue: ${DateFormat('MMM dd, HH:mm').format(reminder.reminderTime)}',
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        reminder.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      ),
                      onPressed: () {
                        // TODO: Toggle pin status
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement add reminder
                },
                child: const Text('Add Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChecklist() {
    if (_activeChecklist == null) return;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _activeChecklist!.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${_activeChecklist!.completedMembers}/${_activeChecklist!.totalMembers} members completed',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _activeChecklist!.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  ),
                  onPressed: () {
                    // TODO: Toggle pin status
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _activeChecklist!.items.length,
                itemBuilder: (context, index) {
                  final item = _activeChecklist!.items[index];
                  final isCompleted = _activeChecklist!.memberCompletions['current_user']?.contains(item.id) ?? false;
                  
                  return CheckboxListTile(
                    title: Text(item.title),
                    subtitle: item.description != null ? Text(item.description!) : null,
                    value: isCompleted,
                    onChanged: (value) {
                      // TODO: Update checklist completion
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWellbeing() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wellbeing Check',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: WellbeingStatus.values.map((status) {
                  return RadioListTile<WellbeingStatus>(
                    title: Text(status.toString().split('.').last),
                    value: status,
                    groupValue: null,
                    onChanged: (value) {
                      // TODO: Update wellbeing status
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Submit wellbeing check
                },
                child: const Text('Submit Check'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHygiene() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hygiene Check',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: HygieneItem.values.where((item) => item != HygieneItem.none).map((item) {
                  return CheckboxListTile(
                    title: Text(item.toString().split('.').last),
                    value: false,
                    onChanged: (value) {
                      // TODO: Update hygiene check
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Submit hygiene check
                },
                child: const Text('Submit Check'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    _chatService.sendMessage(
      tripId: widget.activeTrip!.id,
      senderId: 'current_user', // TODO: Get from auth service
      senderName: 'You',
      content: _messageController.text.trim(),
    );
    
    setState(() {
      _messageController.clear();
    });
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final theme = Theme.of(context);
    final isCurrentUser = message.senderId == 'current_user';
    
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isCurrentUser ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            Text(
              message.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isCurrentUser ? Colors.white : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPluginBar() {
    if (!_showPlugins) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: _showDocuments,
            tooltip: 'Documents',
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: _showReminders,
            tooltip: 'Reminders',
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: _showChecklist,
            tooltip: 'Checklist',
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _showWellbeing,
            tooltip: 'Wellbeing',
          ),
          IconButton(
            icon: const Icon(Icons.sanitizer),
            onPressed: _showHygiene,
            tooltip: 'Hygiene',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.activeTrip == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gang Hangout'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.groups_outlined,
                size: 64,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No Active Trip',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Gang Hangout activates when your trip starts!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.activeTrip!.destination,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${DateFormat('MMM dd').format(widget.activeTrip!.startDate)} - ${DateFormat('MMM dd').format(widget.activeTrip!.endDate)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (_canCloseTrip)
            IconButton(
              icon: const Icon(Icons.archive),
              onPressed: _showTripClosureDialog,
              tooltip: 'Close Trip',
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show trip settings/info
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Trip Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.primaryContainer.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  widget.activeTrip!.isCompleted 
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
                  size: 16,
                  color: widget.activeTrip!.isCompleted
                    ? Colors.green
                    : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.activeTrip!.isCompleted
                      ? 'Trip completed! ${_canCloseTrip ? "You can now close this trip." : "Gang Hangout available for 3 more days."}'
                      : 'Day ${DateTime.now().difference(widget.activeTrip!.startDate).inDays + 1} of your trip',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: widget.activeTrip!.isCompleted
                        ? Colors.green
                        : theme.colorScheme.primary,
                    ),
                  ),
                ),
                if (_activeChecklist != null)
                  TextButton(
                    onPressed: _showChecklist,
                    child: Text(
                      '${_activeChecklist!.completedMembers}/${_activeChecklist!.totalMembers} Checklist',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Pinned Items
          if (_pinnedDocuments.isNotEmpty || _pinnedReminders.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_pinnedDocuments.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          const Icon(Icons.push_pin, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            '${_pinnedDocuments.length} Documents',
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  if (_pinnedReminders.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          const Icon(Icons.push_pin, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            '${_pinnedReminders.length} Reminders',
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Plugin Bar
          _buildPluginBar(),
          
          // Message Input
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              8 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPlugins = !_showPlugins;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message your gang...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 