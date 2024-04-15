import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:regenera/model/Announcement.dart';

import '../../model/Surplus.dart';
import '../../services/authenticationService.dart';

class AnnouncementRepository extends ChangeNotifier {
  // late Database db;
  late FirebaseFirestore cloud;
  final authenticationService = AuthenticationService();
  late String user_id;

  AnnouncementRepository() {
    _initRepository();
  }

  _initRepository() async {
    // db = await DB.instance.database;
    cloud = FirebaseFirestore.instance;
    user_id = authenticationService.getCurrentUuser_id();
  }

  Future<void> initialize() async {
    // db = await DB.instance.database;
    cloud = FirebaseFirestore.instance;
  }

  Future<List<Announcement>> getAllAnnouncements() async {
    try {
      final collectionReference = cloud.collection("Anuncio");
      final querySnapshot = await collectionReference.get();

      final announcements = <Announcement>[];
      for (final documentSnapshot in querySnapshot.docs) {
        final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        final announcement = Announcement.fromMap(data);
        announcements.add(announcement);
      }

      return announcements;
    } catch (e) {
      print('Erro ao recuperar notas: $e');
      return [];
    }
  }

  Future<List<Surplus>> getMyAllSurplusByCategory(String category) async {
    try {
      final collectionReference = cloud.collection("Exedente");
      final querySnapshot = await collectionReference
          .where('category', isEqualTo: category)
          .where('createdBy', isEqualTo: user_id)
          .get();

      final announcements = <Surplus>[];
      for (final documentSnapshot in querySnapshot.docs) {
        final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        final surplus = Surplus.fromMap(data);
        announcements.add(surplus);
      }

      return announcements;
    } catch (e) {
      print('Erro ao recuperar exedentes: $e');
      return [];
    }
  }

  Future<void> saveAnnouncement(Announcement announcement) async {
    try {
      cloud
          .collection("Anuncio")
          .doc(announcement.id)
          .set(announcement.toMap());
    } catch (e) {
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

  Future<void> deleteAnnouncementById(String announcementId) async {
    final documentReference = cloud.collection("Anuncio").doc(announcementId);
    await documentReference.delete();
  }

  Future<Announcement?> getAnnouncementById(String announcementId) async {
    final documentReference = cloud.collection("Anuncio").doc(announcementId);
    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      final announcement = Announcement.fromMap(data);
      return announcement;
    } else {
      return null; // Handle the case where the document doesn't exist
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
}
