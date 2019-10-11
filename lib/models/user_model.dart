import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String,dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context){
    return ScopedModel.of<UserModel>(context);
  }

  @override
  addListener(VoidCallback listener){
    super.addListener(listener);
    _loadCurrentUser();
  }

  Future<Null> _saveUserData(Map<String,dynamic> user){
    this.userData = user;
    Firestore.instance.collection("users").document(firebaseUser.uid).setData(user);
  }
  
  Future<Null> signUp({@required Map<String,dynamic> userData,@required String password,@required VoidCallback onSuccess,@required VoidCallback onFaile})async{
    isLoading = true;
    notifyListeners();
    
    try {
      firebaseUser = await _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: password
      );
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      onFaile();
      notifyListeners();
    }
    
  }
  void signIn({@required String email,@required String password,@required VoidCallback onSuccess,@required VoidCallback onFaile}) async{
    isLoading = true;
    notifyListeners();

    try {
      firebaseUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
    } catch (e) {
      isLoading = false;
      onFaile();
      notifyListeners();
    }
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  void signOut() async{
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _loadCurrentUser() async{
    if(firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }

    notifyListeners();
  }
}