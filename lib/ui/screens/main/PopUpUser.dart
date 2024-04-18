import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regenera/ui/components/bottombar/NavigationBarMain.dart';
import 'package:regenera/ui/screens/main/LoginScreen.dart';

class LogoutPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout', style: TextStyle(color: Colors.black)),
      content: Text('Tem certeza de que deseja fazer logout?', style: TextStyle(color: Colors.black)),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Text('Sim', style: TextStyle(color: Colors.black),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
