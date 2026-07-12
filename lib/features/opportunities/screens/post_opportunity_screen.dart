import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/opportunity_provider.dart';
import '../../../core/theme/app_colors.dart';

class PostOpportunityScreen extends ConsumerStatefulWidget {
  final String startupId;
  final String startupName;
  const PostOpportunityScreen({
    required this.startupId,
    required this.startupName,
    super.key,
  });

  @override
  ConsumerState<PostOpportunityScreen> createState() =>
      _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends ConsumerState<PostOpportunityScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _skillInputController = TextEditingController();
  String _selectedRoleType = 'Software Development';
  final List<String> _skills = [];
  bool _isSubmitting = false;

  final _roleTypes = const [
    'Software Development',
    'Design',
    'Marketing',
    'Operations',
    'Research',
    'Business Analysis',
    'Content Creation',
    'Community Management',
  ];

  void _addSkill() {
    final skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillInputController.clear();
      });
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      return;
    }
    setState(() => _isSubmitting = true);
    await ref
        .read(opportunityRepositoryProvider)
        .createOpportunity(
          startupId: widget.startupId,
          startupName: widget.startupName,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          roleType: _selectedRoleType,
          skillsNeeded: _skills,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post an opportunity')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Opportunity title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Role type',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedRoleType,
              items: _roleTypes
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedRoleType = value!),
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Skills needed',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillInputController,
                    decoration: const InputDecoration(hintText: 'e.g. Flutter'),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                  onPressed: _addSkill,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: _skills
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      onDeleted: () => setState(() => _skills.remove(skill)),
                      backgroundColor: AppColors.secondary.withValues(
                        alpha: 0.15,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            if (_isSubmitting)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Post opportunity'),
              ),
          ],
        ),
      ),
    );
  }
}
