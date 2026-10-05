import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _auth.currentUser;
  Map<String, dynamic>? get userData => _userData;

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
    if (currentUser == null) return;
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        _userData = doc.data() as Map<String, dynamic>;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
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

  // Change Email
  Future<bool> changeEmail(String newEmail) async {
    _setLoading(true);
    _setError(null);
    try {
      // In newer Firebase versions, updateEmail is deprecated and replaced by verifyBeforeUpdateEmail
      // Note: This requires the user to re-authenticate if they haven't recently.
      await currentUser?.verifyBeforeUpdateEmail(newEmail);
      
      // Update Firestore
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'email': newEmail,
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
