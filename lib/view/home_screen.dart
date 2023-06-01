import 'dart:convert';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/res/google_data.dart';
import 'package:chat_app/utils/chatusercard.dart';
import 'package:chat_app/view/profile_screen.dart';
import 'package:chat_app/view_model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../view_model/login_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  List<ChatUser> _searchList = [];

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final loginmodel = Provider.of<LoginModel>(context);
    final homemodel = Provider.of<homeModel>(context);
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.home),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email, ...'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (val) {
                      _searchList.clear();

                      for (var i in list) {
                        if (i.name
                                .toString()
                                .toLowerCase()
                                .contains(val.toLowerCase()) ||
                            i.email
                                .toString()
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                          _searchList.add(i);
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                  )
                : const Text('We Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen(user: homemodel.me);
                  }));
                },
                icon: Icon(Icons.more_vert),
              ),
              // IconButton(
              //   onPressed: () {
              //     loginmodel.SignOut(context);
              //   },
              //   icon: Icon(Icons.logout_outlined),
              // )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add_comment_rounded),
          ),
          body: StreamBuilder(
              stream: homemodel.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data!.docs;
                    list = data.map((e) {
                      return ChatUser.fromJson(e.data());
                    }).toList();
                    print(list);
                    if (list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              _isSearching ? _searchList.length : list.length,
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : list[index],
                            );
                          });
                    } else {
                      return Center(
                          child: Text(
                        "No connection found",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ));
                    }
                }
              }),
        ),
      ),
    );
  }
}
