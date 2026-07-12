import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../opportunities/providers/opportunity_provider.dart';
import '../../opportunities/screens/post_opportunity_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class StartupDashboardScreen extends ConsumerWidget {
  final String startupId;
  final String startupName;
  const StartupDashboardScreen({
    required this.startupId,
    required this.startupName,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesAsync = ref.watch(myOpportunitiesProvider(startupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Post', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PostOpportunityScreen(
                startupId: startupId,
                startupName: startupName,
              ),
            ),
          );
        },
      ),
      body: opportunitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('$err')),
        data: (opportunities) {
          if (opportunities.isEmpty) {
            return const Center(child: Text('No opportunities posted yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              final opp = opportunities[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(opp.title),
                  subtitle: Text(opp.roleType),
                  trailing: Text(
                    opp.status,
                    style: const TextStyle(color: AppColors.success),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
