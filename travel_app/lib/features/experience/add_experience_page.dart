import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/experience.dart';
import '../../services/experience_service.dart';

class AddExperiencePage extends StatefulWidget {
  const AddExperiencePage({super.key});

  @override
  State<AddExperiencePage> createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final List<File> _selectedImages = [];
  final List<String> _selectedTags = [];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final _experienceService = ExperienceService();
  final _imagePicker = ImagePicker();

  Future<void> _pickImages() async {
    final images = await _imagePicker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _pickDate(bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  Future<void> _saveExperience() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedImages.isEmpty ||
        _startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _experienceService.createExperience(
        userId: 'current_user_id', // In real app, get from auth service
        userName: 'Current User', // In real app, get from auth service
        title: _titleController.text,
        description: _descriptionController.text,
        mediaFiles: _selectedImages,
        locations: [_locationController.text],
        startDate: _startDate!,
        endDate: _endDate,
        tags: _selectedTags,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving experience: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Share Experience',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            TextButton(
              onPressed: _saveExperience,
              child: Text(
                'Share',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Location
            TextField(
              controller: _locationController,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _pickDate(true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _startDate != null
                                ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                : 'Select Date',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Date',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _pickDate(false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _endDate != null
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'Select Date',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Image Selection
            Text(
              'Photos',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: _pickImages,
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImages[index - 1],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: theme.colorScheme.error,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedImages.removeAt(index - 1);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Tags
            Text(
              'Tags',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ..._selectedTags.map((tag) => Chip(
                  label: Text(tag),
                  onDeleted: () => _removeTag(tag),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  deleteIconColor: theme.colorScheme.onSecondaryContainer,
                )),
                ActionChip(
                  label: const Text('Add Tag'),
                  onPressed: () {
                    // Show tag input dialog
                  },
                  backgroundColor: theme.colorScheme.primaryContainer,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTagDialog extends StatelessWidget {
  final _controller = TextEditingController();

  _AddTagDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Tag'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter tag name',
        ),
        onSubmitted: (value) {
          Navigator.pop(context, value.trim());
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final tag = _controller.text.trim();
            if (tag.isNotEmpty) {
              Navigator.pop(context, tag);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
} 