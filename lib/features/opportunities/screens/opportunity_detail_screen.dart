import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/opportunity_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../applications/providers/application_provider.dart';
import '../../applications/screens/application_form_screen.dart';

class OpportunityDetailScreen extends ConsumerWidget {
  final OpportunityModel opportunity;
  const OpportunityDetailScreen({required this.opportunity, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;

    final hasAppliedAsync = currentUser == null
        ? const AsyncValue<bool>.data(false)
        : ref.watch(
            hasAppliedProvider((
              studentId: currentUser.uid,
              opportunityId: opportunity.id,
            )),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity details'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              opportunity.startupName,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                opportunity.roleType,
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _MetaRow(icon: Icons.schedule, text: opportunity.roleType),
                  const SizedBox(height: 10),
                  const _MetaRow(
                    icon: Icons.location_on_outlined,
                    text: 'On-campus / Remote',
                  ),
                  const SizedBox(height: 10),
                  _MetaRow(
                    icon: Icons.event_outlined,
                    text: _timeAgo(opportunity.createdAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Skills needed',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: opportunity.skillsNeeded
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      backgroundColor: AppColors.secondary.withValues(
                        alpha: 0.15,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),
            hasAppliedAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('$err'),
              data: (hasApplied) {
                if (hasApplied) {
                  return const SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text('Already applied'),
                    ),
                  );
                }
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ApplicationFormScreen(opportunity: opportunity),
                        ),
                      );
                    },
                    child: const Text('Apply now'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

String _timeAgo(DateTime? date) {
  if (date == null) return 'Just posted';
  final diff = DateTime.now().difference(date);
  if (diff.inDays >= 1) return 'Posted ${diff.inDays}d ago';
  if (diff.inHours >= 1) return 'Posted ${diff.inHours}h ago';
  return 'Posted just now';
}
