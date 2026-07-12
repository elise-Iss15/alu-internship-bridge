import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/opportunity_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/opportunity_model.dart';
import 'opportunity_detail_screen.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});
  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  String _query = '';
  String? _selectedCategory;

  final _categories = const [
    ('Design', Icons.palette_outlined),
    ('Software Development', Icons.code),
    ('Marketing', Icons.campaign_outlined),
    ('Research', Icons.query_stats_outlined),
    ('Other', Icons.more_horiz),
  ];

  @override
  Widget build(BuildContext context) {
    final opportunitiesAsync = ref.watch(opportunityListProvider);
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      body: SafeArea(
        child: opportunitiesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('$err')),
          data: (allOpportunities) {
            var filtered = allOpportunities.where((o) {
              final matchesQuery =
                  _query.isEmpty ||
                  o.title.toLowerCase().contains(_query.toLowerCase()) ||
                  o.startupName.toLowerCase().contains(_query.toLowerCase());
              final matchesCategory =
                  _selectedCategory == null || o.roleType == _selectedCategory;
              return matchesQuery && matchesCategory;
            }).toList();

            final recommended = filtered.isNotEmpty ? filtered.first : null;
            final rest = filtered.length > 1
                ? filtered.sublist(1)
                : <OpportunityModel>[];

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.name.split(' ').first ?? ''} 👋',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Find meaningful ways to contribute.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.notifications_none,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        (user?.name ?? '?').substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    hintText: 'Search opportunities...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 24),
                if (recommended != null) ...[
                  const Text(
                    'Recommended',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HeroCard(opportunity: recommended, userId: user?.uid),
                  const SizedBox(height: 24),
                ],
                const Text(
                  'Browse by category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 76,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _categories.map((c) {
                      final isSelected = _selectedCategory == c.$1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(
                            () => _selectedCategory = isSelected ? null : c.$1,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.primary.withValues(
                                          alpha: 0.08,
                                        ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  c.$2,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c.$1,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _selectedCategory == null
                      ? 'Recent opportunities'
                      : '$_selectedCategory opportunities',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (rest.isEmpty && recommended == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No opportunities found',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ...rest.map(
                    (opp) =>
                        _OpportunityCard(opportunity: opp, userId: user?.uid),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroCard extends ConsumerWidget {
  final OpportunityModel opportunity;
  final String? userId;
  const _HeroCard({required this.opportunity, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final isSaved = user?.savedOpportunities.contains(opportunity.id) ?? false;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OpportunityDetailScreen(opportunity: opportunity),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    opportunity.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (userId != null)
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () => ref
                        .read(userRepositoryProvider)
                        .toggleBookmark(userId!, opportunity.id, isSaved),
                  ),
              ],
            ),
            Text(
              opportunity.startupName,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: opportunity.skillsNeeded
                  .take(3)
                  .map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpportunityCard extends ConsumerWidget {
  final OpportunityModel opportunity;
  final String? userId;
  const _OpportunityCard({required this.opportunity, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final isSaved = user?.savedOpportunities.contains(opportunity.id) ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OpportunityDetailScreen(opportunity: opportunity),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${opportunity.startupName} · ${opportunity.roleType}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (userId != null)
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: AppColors.primary,
                  ),
                  onPressed: () => ref
                      .read(userRepositoryProvider)
                      .toggleBookmark(userId!, opportunity.id, isSaved),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
