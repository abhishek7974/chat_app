import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/res/google_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class homeModel extends ChangeNotifier {
  static User get user => GoogleData.auth.currentUser!;

  ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return GoogleData.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  Future<void> updateUserInfo() async {
    await GoogleData.firestore.collection("users").doc(user.uid).update({
      "name": me.name,
      "about": me.about,
    });
  }

  Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    print('Extension: $ext');
    final ref =
        GoogleData.storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await GoogleData.firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return GoogleData.firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUser) {
    return GoogleData.firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      toId: chatUser.id.toString(),
      msg: msg,
      read: "",
      type: Type.text,
      fromId: user.uid,
      sent: time,
    );
    final ref = GoogleData.firestore.collection(
        'chats/${getConversationID(chatUser.id.toString())}/messages/');
    await ref.doc().set(message.toJson());
  }
}
