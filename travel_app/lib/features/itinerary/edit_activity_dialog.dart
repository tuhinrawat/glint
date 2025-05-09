import 'package:flutter/material.dart';
import '../../models/itinerary.dart';

class EditActivityDialog extends StatefulWidget {
  final Activity activity;
  final int availableSeats;
  final Map<String, dynamic> existingBookings;

  const EditActivityDialog({
    Key? key,
    required this.activity,
    required this.availableSeats,
    required this.existingBookings,
  }) : super(key: key);

  @override
  State<EditActivityDialog> createState() => _EditActivityDialogState();
}

class _EditActivityDialogState extends State<EditActivityDialog> {
  late TextEditingController _participantsController;
  late TextEditingController _costController;
  late String _notes;

  @override
  void initState() {
    super.initState();
    _participantsController = TextEditingController(
      text: widget.existingBookings['participants']?.toString() ?? '1'
    );
    _costController = TextEditingController(
      text: widget.activity.cost.toString()
    );
    _notes = widget.existingBookings['notes'] ?? '';
  }

  @override
  void dispose() {
    _participantsController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text('Edit ${widget.activity.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.existingBookings['isNew'] == true) ...[
            TextFormField(
              controller: _participantsController,
              decoration: InputDecoration(
                labelText: 'Number of Participants',
                helperText: 'Maximum available: ${widget.availableSeats}',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Total Cost',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _notes,
            decoration: const InputDecoration(
              labelText: 'Notes',
              helperText: 'Add any special requirements or preferences',
            ),
            maxLines: 3,
            onChanged: (value) => _notes = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final participants = int.tryParse(_participantsController.text) ?? 1;
            if (participants > widget.availableSeats) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Number of participants exceeds available seats'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final cost = double.tryParse(_costController.text) ?? widget.activity.cost;
            
            final updatedActivity = Activity(
              name: widget.activity.name,
              description: widget.activity.description,
              cost: cost,
              imageUrl: widget.activity.imageUrl,
              startTime: widget.activity.startTime,
              endTime: widget.activity.endTime,
              location: widget.activity.location,
              tags: widget.activity.tags,
              rating: widget.activity.rating,
              reviews: widget.activity.reviews,
              payments: widget.activity.payments,
            );

            Navigator.pop(context, updatedActivity);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
} 