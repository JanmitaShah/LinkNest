import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../categories/domain/category_entity.dart';
import '../../domain/link_entity.dart';
import '../providers/links_provider.dart';

/// Screen for adding a new link
class AddLinkScreen extends ConsumerStatefulWidget {
  const AddLinkScreen({super.key});

  @override
  ConsumerState<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends ConsumerState<AddLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  
  String _selectedCategoryId = 'other';
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _saveLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Parse tags from comma-separated string
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final link = LinkEntity(
        id: const Uuid().v4(),
        url: _urlController.text.trim(),
        title: _titleController.text.trim(),
        categoryId: _selectedCategoryId,
        tags: tags,
        notes: _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.read(linksNotifierProvider.notifier).addLink(link);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link saved successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving link: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Link'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // URL Field
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL *',
                  hintText: 'https://youtube.com/watch?v=...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a URL';
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'Enter a title for this link',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: PredefinedCategories.all.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        Text(category.icon),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategoryId = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Tags Field
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  hintText: 'Enter tags separated by commas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
              ),
              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add any notes about this link',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Link',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}