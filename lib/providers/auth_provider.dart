import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Bypass login when Firebase is not setup
class MockBypassLoginNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void bypass() => state = true;
}

final mockBypassLoginProvider = NotifierProvider<MockBypassLoginNotifier, bool>(
  () {
    return MockBypassLoginNotifier();
  },
);

class MockBypassUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;
  void setUser(UserModel user) => state = user;
}

final mockBypassUserProfileProvider =
    NotifierProvider<MockBypassUserNotifier, UserModel?>(() {
      return MockBypassUserNotifier();
    });

final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  final bypassUser = ref.watch(mockBypassUserProfileProvider);
  if (bypassUser != null) {
    return bypassUser;
  }

  try {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return await ref.watch(firestoreServiceProvider).getUserProfile(user.uid);
    }
  } catch (_) {}

  return null;
});
