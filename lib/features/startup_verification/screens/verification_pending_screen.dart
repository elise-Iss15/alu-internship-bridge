import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/startup_status_provider.dart';
import '../../../data/models/startup_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import 'startup_dashboard_screen.dart';

class VerificationPendingScreen extends ConsumerStatefulWidget {
  final String startupId;
  const VerificationPendingScreen({required this.startupId, super.key});

  @override
  ConsumerState<VerificationPendingScreen> createState() =>
      _VerificationPendingScreenState();
}

class _VerificationPendingScreenState
    extends ConsumerState<VerificationPendingScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(startupStatusProvider(widget.startupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('$err')),
        data: (startup) {
          if (startup == null) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Set up your startup profile'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Startup name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(startupRepositoryProvider)
                          .createProfile(
                            startupId: widget.startupId,
                            name: _nameController.text.trim(),
                            description: _descController.text.trim(),
                          );
                    },
                    child: const Text('Submit for review'),
                  ),
                ],
              ),
            );
          }

          if (startup.status == StartupStatus.pending) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_top,
                      size: 48,
                      color: AppColors.warning,
                    ),
                    SizedBox(height: 16),
                    Text('Your startup is under review'),
                    SizedBox(height: 8),
                    Text(
                      'Usually reviewed within 1-2 business days',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          if (startup.status == StartupStatus.rejected) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    const Text('Your submission was not approved'),
                    const SizedBox(height: 8),
                    Text(startup.rejectionReason ?? 'No reason provided'),
                  ],
                ),
              ),
            );
          }

          return StartupDashboardScreen(
            startupId: widget.startupId,
            startupName: startup.name,
          );
        },
      ),
    );
  }
}
