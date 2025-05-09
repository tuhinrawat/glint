import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';  // Temporarily disabled
import 'firebase_service.dart';

class AppUser {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  AppUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
  });
}

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
  
  AppUser? get currentUser => _isLoggedIn ? AppUser(
    uid: _userId!,
    displayName: _userName,
    email: _userEmail,
    photoURL: _userAvatar,
  ) : null;
  
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
      
      // Firebase Auth is temporarily disabled
      await _initializeDemoMode();
      return;
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      // Continue with fallback authentication
      await _initializeDemoMode();
      return;
    }
  }
  
  // Helper method for initializing demo mode
  Future<void> _initializeDemoMode() async {
    debugPrint('Initializing in demo mode');
    await demoLogin();
  }
  
  /// Login with Google
  Future<bool> loginWithGoogle() async {
    // Firebase Auth is temporarily disabled
    debugPrint('Google login is temporarily disabled, using demo mode');
    return demoLogin();
  }
  
  /// Login with Facebook
  Future<bool> loginWithFacebook() async {
    // Firebase Auth is temporarily disabled
    debugPrint('Facebook login is temporarily disabled, using demo mode');
    return demoLogin();
  }
  
  /// Login with email and password
  Future<bool> loginWithEmailPassword(String email, String password) async {
    // Firebase Auth is temporarily disabled
    debugPrint('Email/password login is temporarily disabled, using demo mode');
    return demoLogin();
  }
  
  /// Create account with email and password
  Future<bool> createAccountWithEmailPassword(String email, String password, String name) async {
    // Firebase Auth is temporarily disabled
    debugPrint('Account creation is temporarily disabled, using demo mode');
    return demoLogin();
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