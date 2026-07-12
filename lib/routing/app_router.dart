import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/opportunities/screens/student_shell_screen.dart';
import '../features/startup_verification/screens/verification_pending_screen.dart';
import '../data/models/user_model.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('$err'))),
      data: (user) {
        if (user == null) {
          return const OnboardingScreen();
        }
        if (user.role == UserRole.student) {
          return const StudentShellScreen();
        }
        return VerificationPendingScreen(startupId: user.uid);
      },
    );
  }
}
