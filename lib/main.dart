import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/res/google_data.dart';
import 'package:chat_app/view_model/home_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/home_screen.dart';
import 'view/login_screen.dart';
import 'view_model/login_model.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginModel>(create: (_) => LoginModel()),
        ChangeNotifierProvider<homeModel>(create: (_) => homeModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20,
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            centerTitle: true,
            elevation: 1,
            backgroundColor: Colors.white,
          ),
          primarySwatch: Colors.blue,
        ),
        home:
            GoogleData.auth.currentUser == null ? LoginScreen() : HomeScreen(),
      ),
    );
  }
}
