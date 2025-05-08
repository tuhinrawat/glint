// import 'package:firebase_auth/firebase_auth.dart';  // Temporarily disabled
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';  // Temporarily disabled
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  // final FirebaseAuth _auth = FirebaseAuth.instance;  // Temporarily disabled
  // final GoogleSignIn _googleSignIn = GoogleSignIn();  // Temporarily disabled
  
  // Singleton pattern
  factory FirebaseService() => _instance;
  FirebaseService._internal();
  
  // Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        debugPrint('Firebase already initialized');
        return;
      }
      
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
    }
  }
  
  // Check if user is signed in
  bool isUserSignedIn() {
    // Temporarily disabled
    return false;
    // try {
    //   return _auth.currentUser != null;
    // } catch (e) {
    //   debugPrint('Error checking if user is signed in: $e');
    //   return false;
    // }
  }
  
  // Get current user
  dynamic getCurrentUser() {
    // Temporarily disabled
    return null;
    // try {
    //   return _auth.currentUser;
    // } catch (e) {
    //   debugPrint('Error getting current user: $e');
    //   return null;
    // }
  }
  
  // Sign in with Google - Temporarily disabled
  Future<dynamic> signInWithGoogle() async {
    throw UnimplementedError('Google Sign-In is temporarily disabled');
  }
  
  // Sign in with Facebook
  Future<dynamic> signInWithFacebook() async {
    try {
      // Trigger the authentication flow
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status != LoginStatus.success) {
        return null; // User canceled or failed sign-in
      }
      
      // Create a credential from the access token
      // final OAuthCredential credential = FacebookAuthProvider.credential(  // Temporarily disabled
      //   result.accessToken!.token,
      // );
      
      // Sign in with credential
      // return await _auth.signInWithCredential(credential);  // Temporarily disabled
      return null;
    } catch (e) {
      debugPrint('Error signing in with Facebook: $e');
      return null;
    }
  }
  
  // Sign in with email and password
  Future<dynamic> signInWithEmailPassword(String email, String password) async {
    throw UnimplementedError('Email/Password sign-in is temporarily disabled');
    // try {
    //   return await _auth.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    // } catch (e) {
    //   debugPrint('Error signing in with email/password: $e');
    //   return null;
    // }
  }
  
  // Create user with email and password
  Future<dynamic> createUserWithEmailPassword(String email, String password) async {
    throw UnimplementedError('Email/Password sign-up is temporarily disabled');
    // try {
    //   return await _auth.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    // } catch (e) {
    //   debugPrint('Error creating user with email/password: $e');
    //   return null;
    // }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from social providers if needed
      // await _googleSignIn.signOut();  // Temporarily disabled
      await FacebookAuth.instance.logOut();
      
      // Sign out from Firebase
      // await _auth.signOut();  // Temporarily disabled
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
} 