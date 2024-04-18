import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../model/User.dart';
class UserRepository extends ChangeNotifier {
  // // late Database db;

  UserRepository() {
    _initRepository();
  }

  _initRepository() async {
    // db = await DB.instance.database;
  }

  Future<void> initialize() async {
    // db = await DB.instance.database;
  }

  Future<void> createUser(BuildContext context, User user) async {

    // Salvando remotamente
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      print("salvou");

    } catch (e) {
      print('Erro ao salvar nota na nuvem: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      // await db.insert('users', user.toMap());
      notifyListeners();
    } catch (e) {
      // Trate qualquer erro de inserção aqui
      print('Erro ao atualizar usuario: $e');
    }
  }

  Future<void> deleteUser(User user) async {
    try {
      // await db.delete('users', where: 'id = ?', whereArgs: [user.id]);
    } catch (e) {
      print('Erro ao excluir user: $e');
    }
  }
}
