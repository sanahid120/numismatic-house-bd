import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  bool _profileLoaded = false;
  Completer<void> _profileCompleter = Completer<void>();
  late final StreamSubscription<User?> _authSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSubscription;

  AuthProvider() {
    _authSubscription = _auth.authStateChanges().listen((user) async {
      await _profileSubscription?.cancel();
      _userData = null;
      _profileLoaded = user == null;
      if (user != null) _profileCompleter = Completer<void>();
      if (_profileLoaded && !_profileCompleter.isCompleted) {
        _profileCompleter.complete();
      }
      notifyListeners();
      if (user != null) {
        _profileSubscription = _firestore
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((document) {
              if (_auth.currentUser?.uid != user.uid) return;
              final profile = document.data();
              _userData = profile;
              if (profile != null && user.emailVerified &&
                  profile['email'] != user.email) {
                unawaited(_syncVerifiedEmail(user.uid, user.email));
              }
              _profileLoaded = true;
              if (!_profileCompleter.isCompleted) _profileCompleter.complete();
              notifyListeners();
            }, onError: (Object error) {
              debugPrint('Error watching user profile: $error');
              _userData = null;
              _profileLoaded = true;
              if (!_profileCompleter.isCompleted) _profileCompleter.complete();
              notifyListeners();
            });
      }
    });
  }

  Future<void> _syncVerifiedEmail(String uid, String? email) async {
    if (email == null || email.isEmpty || _auth.currentUser?.uid != uid) return;
    try {
      await _firestore.collection('users').doc(uid).update({'email': email});
    } catch (error) {
      debugPrint('Could not sync verified email to profile: $error');
    }
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _auth.currentUser;
  Map<String, dynamic>? get userData => _userData;
  bool get isAdmin => _userData?['role'] == 'admin';
  bool get profileLoaded => _profileLoaded;
  Future<void> get profileReady => _profileCompleter.future;

  @override
  void dispose() {
    _authSubscription.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Fetch User Data from Firestore
  Future<void> fetchUserData() async {
    final user = currentUser;
    if (user == null) {
      _userData = null;
      _profileLoaded = true;
      if (!_profileCompleter.isCompleted) _profileCompleter.complete();
      notifyListeners();
      return;
    }
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (currentUser?.uid != user.uid) return;
      if (doc.exists) {
        _userData = doc.data();
      } else {
        _userData = null;
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      _userData = null;
    } finally {
      _profileLoaded = true;
      if (!_profileCompleter.isCompleted) _profileCompleter.complete();
      notifyListeners();
    }
  }

  // Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        
        // Save to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'role': 'user', // Default role
          'profilePic': '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await user.sendEmailVerification();
        await _auth.signOut();
      }
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError("An unexpected error occurred");
      _setLoading(false);
      return false;
    }
  }

  // Sign In
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null && !result.user!.emailVerified) {
        _setError("Please verify your email address before logging in.");
        await _auth.signOut();
        _setLoading(false);
        return false;
      }

      await fetchUserData();
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError("An unexpected error occurred");
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (_) {
      _setError('Could not send a password reset email. Try again.');
      _setLoading(false);
      return false;
    }
  }

  // Update Profile Info
  Future<bool> updateProfile({required String firstName, required String lastName}) async {
    _setLoading(true);
    try {
      await currentUser?.updateDisplayName('$firstName $lastName');
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'firstName': firstName,
        'lastName': lastName,
      });
      await fetchUserData();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Change Password
  Future<bool> changePassword(String newPassword) async {
    _setLoading(true);
    try {
      await currentUser?.updatePassword(newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> reauthenticateAndChangePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final user = currentUser;
      final email = user?.email;
      if (user == null || email == null || email.isEmpty) {
        throw StateError('This account cannot change its password here.');
      }
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Change Email
  Future<bool> changeEmail(String newEmail) async {
    _setLoading(true);
    _setError(null);
    try {
      // In newer Firebase versions, updateEmail is deprecated and replaced by verifyBeforeUpdateEmail
      // Note: This requires the user to re-authenticate if they haven't recently.
      await currentUser?.verifyBeforeUpdateEmail(newEmail);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Delete Account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    try {
      String uid = currentUser!.uid;
      await currentUser?.delete();
      await _firestore.collection('users').doc(uid).delete();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    _userData = null;
    notifyListeners();
  }
}
