import 'package:e_store/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

//create user object based on FirebaseUser
  UserModel _userBasedOnFirebaseUser(User firebaseUser) {
    return firebaseUser != null ? UserModel(uid: firebaseUser.uid) : null;
  }

  //todo auth change user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userBasedOnFirebaseUser);
  }

  //sign in in anon
  Future<UserModel> signInAnon() async {
    try {
      UserCredential authResult = await _auth.signInAnonymously();
      User firebaseUser = authResult.user;
      return _userBasedOnFirebaseUser(firebaseUser);
    } catch (e, trace) {
      print("Error -> $e \n $trace");
      return null;
    }
  }

  //signIn with email and password
  Future<UserModel> signInWithCredentials(
      {@required String email, @required String password}) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      return _userBasedOnFirebaseUser(firebaseUser);
    } catch (e, trace) {
      print("Error -> $e \n $trace");
      return null;
    }
  }

  // signUp with email and password
  Future<UserModel> signUpWithCredentials(
      {@required String email, @required String password}) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      return _userBasedOnFirebaseUser(firebaseUser);
    } catch (e, trace) {
      print("Error -> $e \n $trace");
      return null;
    }
  }

  //signOut
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e, trace) {
      print("Error -> $e \n $trace");
      return null;
    }
  }
}
