import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:regenera/core/repository/AnnouncementRepository.dart';
import 'package:regenera/ui/components/bottombar/NavigationBarMain.dart';
import 'package:regenera/ui/screens/main/HomeScreen.dart';
import 'package:regenera/ui/screens/main/LoginScreen.dart';
import 'package:regenera/viewmodel/AnnouncementViewModel.dart';
import 'firebase_options.dart';
import 'navigation/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // sqfliteFfiInit();

  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AnnouncementRepository()),
      ChangeNotifierProvider(
          create: (context) => AnnouncementViewModel(AnnouncementRepository()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarColor: Colors.white,
    ));
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            theme: ThemeData(
              bottomSheetTheme:  BottomSheetThemeData(backgroundColor: Colors.white),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
                bodyMedium: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              useMaterial3: true,
              primaryColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.white,
                  background: Colors.white,
                  brightness: Brightness.dark,
                  primary: Colors.white),
            ),
            home: NavigationBarMain(),
            onGenerateRoute: router.generator,
          );
        } else {
          // User is not logged in, show LoginPage
          return MaterialApp(
            theme: ThemeData(
              bottomSheetTheme:  BottomSheetThemeData(backgroundColor: Colors.white),
              bottomAppBarTheme: BottomAppBarTheme(color: Colors.black54),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
                bodyMedium: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              useMaterial3: true,
              primaryColor: Colors.black,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.white,
                  background: Colors.white,
                  brightness: Brightness.light,
                  primary: Colors.white),
            ),
            home: LoginPage(),
            onGenerateRoute: router.generator,
          );
        }
      },
    );
  }
}
