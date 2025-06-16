import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Check if email is verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Add a small delay to ensure Firebase is ready
      await Future.delayed(const Duration(milliseconds: 100));

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Additional validation
      if (userCredential.user?.uid == null) {
        throw FirebaseAuthException(
          code: 'sign-in-failed',
          message: 'Failed to sign in. Please try again.',
        );
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      // Add a small delay to ensure Firebase is ready
      await Future.delayed(const Duration(milliseconds: 100));

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Additional validation
      if (userCredential.user?.uid == null) {
        throw FirebaseAuthException(
          code: 'account-creation-failed',
          message: 'Failed to create account. Please try again.',
        );
      }

      // Update user profile with username
      await userCredential.user?.updateDisplayName(username);

      // Send email verification
      await sendEmailVerification();

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Sign out first to ensure clean state
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'sign-in-cancelled',
          message: 'Google sign in was cancelled',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Validate tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-google-auth-token',
          message: 'Failed to get Google authentication tokens',
        );
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Add a small delay before Firebase operation
      await Future.delayed(const Duration(milliseconds: 100));

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Additional validation
      if (userCredential.user?.uid == null) {
        throw FirebaseAuthException(
          code: 'google-sign-in-failed',
          message: 'Failed to sign in with Google. Please try again.',
        );
      }

      // Send email verification for Google sign-in
      await sendEmailVerification();

      return userCredential;
    } catch (e) {
      // Ensure clean state on error
      await _googleSignIn.signOut();
      throw _handleAuthException(e);
    }
  }

  // Sign out with proper cleanup
  Future<void> signOut() async {
    try {
      // Sign out from both services
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      // Force cleanup even if there's an error
      try {
        await _auth.signOut();
      } catch (_) {}
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
      throw _handleAuthException(e);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Generate and store verification code
  Future<String> generateAndStoreVerificationCode(String email) async {
    try {
      // Generate a random 4-digit code
      final random = Random();
      final code = (1000 + random.nextInt(9000)).toString();

      // Store the code in Firestore with timestamp
      await _firestore.collection('verification_codes').doc(email).set({
        'code': code,
        'timestamp': FieldValue.serverTimestamp(),
        'used': false,
      });

      // Send email with the code
      await _auth.sendPasswordResetEmail(email: email.trim());

      return code;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Verify the code
  Future<bool> verifyCode(String email, String code) async {
    try {
      final doc =
          await _firestore.collection('verification_codes').doc(email).get();

      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>;
      final storedCode = data['code'] as String;
      final timestamp = data['timestamp'] as Timestamp;
      final used = data['used'] as bool;

      // Check if code is expired (15 minutes) or already used
      final now = DateTime.now();
      final codeTime = timestamp.toDate();
      if (now.difference(codeTime).inMinutes > 15 || used) {
        return false;
      }

      if (code == storedCode) {
        // Mark code as used
        await doc.reference.update({'used': true});
        return true;
      }

      return false;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'Email is already in use.';
        case 'invalid-email':
          return 'Email address is invalid.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'operation-not-allowed':
          return 'Operation not allowed.';
        case 'account-exists-with-different-credential':
          return 'Account exists with different credentials.';
        case 'network-request-failed':
          return 'Network error occurred.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'invalid-verification-code':
          return 'Invalid verification code.';
        case 'invalid-verification-id':
          return 'Invalid verification ID.';
        case 'sign-in-cancelled':
          return 'Sign in was cancelled.';
        case 'sign-in-failed':
        case 'account-creation-failed':
        case 'google-sign-in-failed':
          return e.message ?? 'Authentication failed. Please try again.';
        case 'missing-google-auth-token':
          return 'Failed to authenticate with Google. Please try again.';
        default:
          return e.message ?? 'An error occurred. Please try again.';
      }
    }
    return e.toString();
  }
}
