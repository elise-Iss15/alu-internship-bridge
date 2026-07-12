import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/opportunity_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/application_provider.dart';

class ApplicationFormScreen extends ConsumerStatefulWidget {
  final OpportunityModel opportunity;
  const ApplicationFormScreen({required this.opportunity, super.key});

  @override
  ConsumerState<ApplicationFormScreen> createState() =>
      _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends ConsumerState<ApplicationFormScreen> {
  final _motivationController = TextEditingController();
  final _skillController = TextEditingController();
  String _availability = 'Part-time';
  bool _isSubmitting = false;

  final _availabilityOptions = const [
    'Part-time',
    'Full-time',
    'Flexible hours',
  ];

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    if (_motivationController.text.trim().isEmpty ||
        _skillController.text.trim().isEmpty)
      return;

    setState(() => _isSubmitting = true);
    await ref
        .read(applicationRepositoryProvider)
        .submitApplication(
          studentId: user.uid,
          studentName: user.name,
          opportunityId: widget.opportunity.id,
          opportunityTitle: widget.opportunity.title,
          startupId: widget.opportunity.startupId,
          motivation: _motivationController.text.trim(),
          relevantSkill: _skillController.text.trim(),
          availability: _availability,
        );
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply — ${widget.opportunity.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Why are you interested?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _motivationController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'A couple of sentences is enough',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Relevant skill or experience',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _skillController,
              decoration: const InputDecoration(
                hintText: 'e.g. Built 2 Flutter apps',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Availability',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _availability,
              items: _availabilityOptions
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _availability = value!),
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 32),
            if (_isSubmitting)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit application'),
              ),
          ],
        ),
      ),
    );
  }
}
