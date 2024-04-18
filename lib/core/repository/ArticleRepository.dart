import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:regenera/model/Article.dart';

import '../../model/Surplus.dart';
import '../../services/authenticationService.dart';

class ArticleRepository extends ChangeNotifier {
  // late Database db;
  late FirebaseFirestore cloud;
  final authenticationService = AuthenticationService();
  late String user_id;

  ArticleRepository() {
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

  Future<List<Article>> getAllArticles() async {
    try {
      final collectionReference = cloud.collection("Artigo");
      final querySnapshot = await collectionReference.get();

      final articles = <Article>[];
      for (final documentSnapshot in querySnapshot.docs) {
        // Verifique se o documento existe antes de acessar data()
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data();
          final article = Article.fromMap(data);
          articles.add(article);
        } else {
          print('Documento não encontrado: ${documentSnapshot.id}');
        }
      }

      print(articles.first.title);
      return articles;

    } catch (e) {
      print('Erro ao recuperar artigo: $e');
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

      final articles = <Surplus>[];
      for (final documentSnapshot in querySnapshot.docs) {
        final Map<String, dynamic> data = documentSnapshot.data();
        final surplus = Surplus.fromMap(data);
        articles.add(surplus);
      }

      return articles;
    } catch (e) {
      print('Erro ao recuperar exedentes: $e');
      return [];
    }
  }

  Future<void> saveArticle(Article article) async {
    try {
      cloud
          .collection("Artigo")
          .doc(article.id)
          .set(article.toMap());
    } catch (e) {
      print("Erro ao salvar em nuvem: $e");
    }
  }

  Future<void> deleteNote(Article note) async {
    try {
      // await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
      // await db.delete('note_lesson_relation', where: 'note_id = ?', whereArgs: [note.id]);
    } catch (e) {
      print('Erro ao excluir nota: $e');
    }
  }

  Future<void> deleteArticleById(String articleId) async {
    final documentReference = cloud.collection("Anuncio").doc(articleId);
    await documentReference.delete();
  }

  Future<Article?> getArticleById(String articleId) async {
    final documentReference = cloud.collection("Anuncio").doc(articleId);
    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      final article = Article.fromMap(data);
      return article;
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

  Future<void> updateNote(Article note) async {
    try {
      // await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    } catch (e) {
      print('Erro ao atualizar nota: $e');
    }
  }
}
