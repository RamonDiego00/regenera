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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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
        final Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final announcement = Announcement.fromMap(data);
        announcements.add(announcement);
      }

      return announcements;
    } catch (e) {
      print('Erro ao recuperar anuncios: $e');
      return [];
    }
  }

  Future<List<Announcement>> searchAnnouncements(String query) async {
    try {
      // Verifique se a consulta está vazia
      if (query.isEmpty) {
        // Se estiver vazia, retorne todos os anúncios
        return getAllAnnouncements();
      } else {
        // Caso contrário, realize a consulta ao Firestore para buscar anúncios com base na consulta
        final QuerySnapshot querySnapshot = await _firestore
            .collection('Anuncio')
            .where('negotiated', isGreaterThanOrEqualTo: query)
            .get();

        // Converta os documentos retornados em objetos Announcement
        final List<Announcement> announcements = querySnapshot.docs
            .map((doc) => Announcement.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return announcements;
      }
    } catch (e) {
      // Em caso de erro, você pode lidar com isso aqui
      print('Erro ao buscar anúncios: $e');
      throw e;
    }
  }

  Future<List<Announcement>> getAllFavoriteAnnouncements() async {
    try {
      final collectionReference = cloud.collection("Anuncio");
      final querySnapshot =
          await collectionReference.where('userId', isEqualTo: user_id).get();

      final announcements = <Announcement>[];
      for (final documentSnapshot in querySnapshot.docs) {
        final Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final announcement = Announcement.fromMap(data);
        announcements.add(announcement);
      }

      return announcements;
    } catch (e) {
      print('Erro ao recuperar anuncios: $e');
      return [];
    }
  }

  Future<List<Surplus>> getMyAllSurplusByCategory(String category) async {
    try {
      final collectionReference = cloud.collection("Exedente");
      final querySnapshot = await collectionReference
          .where('category', isEqualTo: category)
          .where('userId', isEqualTo: user_id)
          .get();

      final announcements = <Surplus>[];
      for (final documentSnapshot in querySnapshot.docs) {
        final Map<String, dynamic> data = documentSnapshot.data();
        final surplus = Surplus.fromMap(data);
        announcements.add(surplus);
      }

      return announcements;
    } catch (e) {
      print('Erro ao recuperar exedentes: $e');
      return [];
    }
  }

  Future<Surplus> getSurplusById(String id) async {
    try {
      final collectionReference = cloud.collection("Exedente");
      final querySnapshot =
          await collectionReference.where('id', isEqualTo: id).get();

      // final announcements = Surplus;
      // for (final documentSnapshot in querySnapshot.docs) {
      //   final Map<String, dynamic> data = documentSnapshot.data();
      //   final surplus = Surplus.fromMap(data);
      //   announcements.add(surplus);
      // }

      if (querySnapshot.docs.isNotEmpty) {
        final Map<String, dynamic> data = querySnapshot.docs.first.data()!;
        final surplus = Surplus.fromMap(data);
        return surplus;
      } else {
        return Surplus(
          id: "3",
          userId: "user2",
          location: "location",
          name: "Serviço",
          description:
              "Qualquer tipo de serviço que ajude o plantio ou manutenção dos jardins",
          photos: ["image3.jpg"],
          category: "Ferramenta",
          units: "kg",
          date: DateTime.now().toString(),
        );
      }
    } catch (e) {
      print('Erro ao recuperar exedentes: $e');
      return Surplus(
        id: "3",
        userId: "user2",
        location: "location",
        name: "Serviço",
        description:
            "Qualquer tipo de serviço que ajude o plantio ou manutenção dos jardins",
        photos: ["image3.jpg"],
        category: "Ferramenta",
        units: "kg",
        date: DateTime.now().toString(),
      );
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
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
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
