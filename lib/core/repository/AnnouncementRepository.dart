import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:regenera/model/Announcement.dart';


class AnnouncementRepository extends ChangeNotifier {
  // late Database db;
  late FirebaseFirestore cloud;

  NoteRepository() {
    _initRepository();
  }

  _initRepository() async {
    // db = await DB.instance.database;
    cloud = FirebaseFirestore.instance;
  }

  Future<void> initialize() async {
    // db = await DB.instance.database;
    cloud = FirebaseFirestore.instance;
  }

  Future<void> saveNote(Announcement note) async {
    try {
      // await db.insert('notes', note.toMap());
      notifyListeners();

      // depois de um tempinho é melhor deletar ela para
      // limpar os dados do celular e deixar em nuvem
    } catch (e) {
      // Trate qualquer erro de inserção aqui
      print('Erro ao salvar nota: $e');
    }

    try{
      // passar o id do documento que já existe ele vai atualizar no firestore
    cloud.collection("Notes").doc(note.id).set(note.toMap()) ;

    } catch(e){
      print("Erro ao salvar em nuvem: $e");
    }

  }

  Future<void> deleteNote(Announcement note) async {
    try {
      // await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
      // await db.delete('note_lesson_relation', where: 'note_id = ?', whereArgs: [note.id]);
    } catch (e) {
      print('Erro ao excluir nota: $e');
    }
  }
  Future<void> deleteAllNotes() async {
    try {
      // await db.delete('notes');
      notifyListeners();
    } catch (e) {
      print('Erro ao excluir todas as notas: $e');
    }
  }

  Future<void> updateNote(Announcement note) async {
    try {
      // await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    } catch (e) {
      print('Erro ao atualizar nota: $e');
    }
  }


  Future<List<Announcement>> getAllNotes() async {
    try {
      // final List<Map<String, dynamic>> noteMaps = await db.query('notes');
      final List<Announcement> notes = [];

      // for (var noteMap in noteMaps) {


        // final Announcement note = Announcement(
        //   user_id: noteMap['user_id'] ,
        //   id: noteMap['id'],
        //   title: noteMap['title'],
        //   message: noteMap['message'],
        //   category: noteMap['category'],
        // );

        // notes.add(note);
      // }

      return notes;
    } catch (e) {
      print('Erro ao recuperar notas: $e');
      return [];
    }
  }




}
