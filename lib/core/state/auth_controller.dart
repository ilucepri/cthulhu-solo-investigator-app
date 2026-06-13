import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(firebaseAuthProvider).authStateChanges();
});

final guestModeProvider = StateProvider<bool>((_) => false);

final authActionsProvider = Provider<AuthActions>((ref) => AuthActions(ref));

class AuthActions {
  final Ref ref;
  AuthActions(this.ref);

  FirebaseAuth get _auth => ref.read(firebaseAuthProvider);

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    ref.read(guestModeProvider.notifier).state = false;
  }

  Future<void> registerWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    ref.read(guestModeProvider.notifier).state = false;
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    ref.read(guestModeProvider.notifier).state = false;
  }

  Future<void> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    await _auth.signInWithCredential(oauthCredential);
    ref.read(guestModeProvider.notifier).state = false;
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
    ref.read(guestModeProvider.notifier).state = false;
  }

  void continueAsGuest() {
    ref.read(guestModeProvider.notifier).state = true;
  }

  void exitGuest() {
    ref.read(guestModeProvider.notifier).state = false;
  }
}
