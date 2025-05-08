import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

/// Service to manage authentication state and user login/logout
class AuthService with ChangeNotifier {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userAvatarKey = 'user_avatar';
  
  bool _isLoggedIn = false;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userAvatar;
  
  final FirebaseService _firebaseService = FirebaseService();
  
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  
  AuthService._internal();
  
  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userAvatar => _userAvatar;
  
  /// Initialize the auth service by loading saved state
  Future<void> initialize() async {
    try {
      // Try initializing Firebase, but don't rely on it
      await _firebaseService.initializeFirebase().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('Firebase initialization timed out, using demo mode');
          throw Exception('Firebase initialization timed out');
        },
      );
      
      // Check if user is already logged in with Firebase
      final currentUser = _firebaseService.getCurrentUser();
      
      if (currentUser != null) {
        // User is logged in with Firebase
        _isLoggedIn = true;
        _userId = currentUser.uid;
        _userName = currentUser.displayName;
        _userEmail = currentUser.email;
        _userAvatar = currentUser.photoURL;
        
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      // Continue with fallback authentication
      await _initializeDemoMode();
      return;
    }
    
    // If not logged in with Firebase, check SharedPreferences as fallback
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (_isLoggedIn) {
      _userId = prefs.getString(_userIdKey);
      _userName = prefs.getString(_userNameKey);
      _userEmail = prefs.getString(_userEmailKey);
      _userAvatar = prefs.getString(_userAvatarKey);
    }
    
    notifyListeners();
  }
  
  // Helper method for initializing demo mode
  Future<void> _initializeDemoMode() async {
    debugPrint('Initializing in demo mode');
    await demoLogin();
  }
  
  /// Login with Google
  Future<bool> loginWithGoogle() async {
    try {
      final userCredential = await _firebaseService.signInWithGoogle().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('Google login timed out, using demo mode');
          throw Exception('Google login timed out');
        },
      );
      
      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;
        return _updateUserData(
          userId: user.uid,
          userName: user.displayName,
          userEmail: user.email,
          userAvatar: user.photoURL,
          provider: 'google',
        );
      }
      // If Firebase login fails, use demo mode
      return demoLogin();
    } catch (e) {
      debugPrint('Google login error: $e');
      // Fall back to demo login on any error
      return demoLogin();
    }
  }
  
  /// Login with Facebook
  
  /// Login with email and password
  Future<bool> loginWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseService.signInWithEmailPassword(email, password);
      
      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;
        return _updateUserData(
          userId: user.uid,
          userName: user.displayName ?? email.split('@')[0],
          userEmail: user.email,
          userAvatar: user.photoURL,
          provider: 'email',
        );
      }
      return false;
    } catch (e) {
      debugPrint('Email/password login error: $e');
      return false;
    }
  }
  
  /// Create account with email and password
  Future<bool> createAccountWithEmailPassword(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseService.createUserWithEmailPassword(email, password);
      
      if (userCredential != null && userCredential.user != null) {
        // Update user profile
        await userCredential.user!.updateDisplayName(name);
        
        final user = userCredential.user!;
        return _updateUserData(
          userId: user.uid,
          userName: name,
          userEmail: user.email,
          userAvatar: null,
          provider: 'email',
        );
      }
      return false;
    } catch (e) {
      debugPrint('Account creation error: $e');
      return false;
    }
  }
  
  /// Legacy login method (for compatibility with existing code)
  Future<bool> login({
    required String provider,
    required String userId,
    String? userName,
    String? userEmail,
    String? userAvatar,
  }) async {
    return _updateUserData(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      userAvatar: userAvatar,
      provider: provider,
    );
  }
  
  /// Update user data in the service and save to preferences
  Future<bool> _updateUserData({
    required String userId,
    String? userName,
    String? userEmail,
    String? userAvatar,
    required String provider,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Update local state
      _isLoggedIn = true;
      _userId = userId;
      _userName = userName;
      _userEmail = userEmail;
      _userAvatar = userAvatar;
      
      // Save to persistent storage
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userIdKey, userId);
      if (userName != null) await prefs.setString(_userNameKey, userName);
      if (userEmail != null) await prefs.setString(_userEmailKey, userEmail);
      if (userAvatar != null) await prefs.setString(_userAvatarKey, userAvatar);
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }
  
  /// Simulate login for demo purposes
  Future<bool> demoLogin() async {
    return login(
      provider: 'demo',
      userId: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      userName: 'Demo User',
      userEmail: 'demo@glintapp.com',
    );
  }
  
  /// Log user out
  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _firebaseService.signOut();
      
      final prefs = await SharedPreferences.getInstance();
      
      // Clear auth state
      _isLoggedIn = false;
      _userId = null;
      _userName = null;
      _userEmail = null;
      _userAvatar = null;
      
      // Clear from persistent storage
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userAvatarKey);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
} 