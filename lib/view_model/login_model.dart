import 'dart:math';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/res/google_data.dart';
import 'package:chat_app/utils/dailog.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel extends ChangeNotifier {

   User get user => GoogleData.auth.currentUser!;
   String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  
  

  void handleSignIn(BuildContext context) {
    showProgressBar(context);
    signInWithGoogle().then((user) async {
      Navigator.of(context).pop();
      print('\nUser: ${user!.user}');
      print('\nUser: ${user.additionalUserInfo}');
      if((await userExists())){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return HomeScreen();
      })); 
      }else{
        await createUser().then((value) {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return HomeScreen();
      })); 
        });
      }
     
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await GoogleData.auth.signInWithCredential(credential);
    } catch (e) {
      print('\n_signInWithGoogle: $e');
      showToast('Something Went Wrong (Check Internet!)');
      return null;
    }
  }

  SignOut(BuildContext context) async {
    await GoogleData.auth.signOut().then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return LoginScreen();
      }));
    });
  }
   Future<bool> userExists() async {
    return (await GoogleData.firestore.collection("users").doc(user.uid).get()).exists;
  }

   Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid.toString(),
      name: user.displayName.toString(),
      email: user.email,
      about: "hey I am using chat app",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    await GoogleData.firestore.collection("users").doc(user.uid).set(chatUser.toJson());
  }

   Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return GoogleData.firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
