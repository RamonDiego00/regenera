import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:regenera/ui/screens/main/HomeScreen.dart';
import 'package:regenera/ui/screens/main/LoginScreen.dart';


final router = FluroRouter();

void defineRoutes() {
  router.define(
    '/home',
    handler: Handler(
      handlerFunc: (context, _) => const  HomeScreen(),
    ),
  );

  router.define(
    '/login',
    handler: Handler(
      handlerFunc: (context, _) => const LoginPage(),
    ),
  );
}