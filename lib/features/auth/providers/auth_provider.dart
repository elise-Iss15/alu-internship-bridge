import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
);

// Raw auth state (logged in / out) — used for routing decisions
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

// Full user profile (role, name) once logged in
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map(
            (doc) => doc.exists
                ? UserModel.fromFirestore(doc.id, doc.data()!)
                : null,
          );
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

// Sign up / sign in actions — AsyncNotifier is the current Riverpod pattern
class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // no initial state needed
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password, name: name, role: role),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
final userRepositoryProvider = Provider(
  (ref) => UserRepository(FirebaseFirestore.instance),
);
