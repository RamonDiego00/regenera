import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../core/repository/ArticleRepository.dart';
import '../model/Article.dart';
import '../model/Surplus.dart';

class ArticleViewModel extends ChangeNotifier {
  final ArticleRepository _articleRepository;

  ArticleViewModel(this._articleRepository) {
    _loadApiKey();
    _articleRepository.initialize();
  }

  List<Article> _article = [];

  String _apiKey = "";

  Future<void> _loadApiKey() async {
    // await dotenv.load(fileName: '.env');
    // _apiKey = dotenv.env['API_KEY']!;
  }

  Future<void> createNewArticle(
      String title, String description, String category) async {
    // await _articleRepository.initialize();
    final uuid = Uuid();
    String id = uuid.v4();
    String user_id = _articleRepository.user_id;

    Article newArticle = Article(
        id: id,
        userId: user_id,
        title: title,
        description: description,
        category: category);

    await _articleRepository.saveArticle(newArticle);
  }

  Future<List<Article>> getAllArticles() async {
    _articleRepository.initialize();
    print("chamou");
    return await _articleRepository.getAllArticles();
     _article;
    notifyListeners();
  }

  Future<void> deleteArticle(Article user) async {
    // await _noteRepository.initialize();
    // await _articleRepository.deleteArticle(user);
  }

  Future<void> updateArticle(Article user) async {
    // await _noteRepository.initialize();
    // await _articleRepository.updateArticle(user);
  }

  Future<List<Surplus>> getOptionsArticle() async {
    // Create two fictitious Surplus objects
    final surplus1 = Surplus(
      id: "1",
      userId: "user1",
      location: "location",
      name: "Alimentício",
      description:
          "Na próxima etapa todos os exedentes do tipo alimentício serão listados",
      photos: ["image1.jpg,image2.jpg"],
      category: "Comida",
      units: "kg",
      date: DateTime.now().toString(),
    );
    final surplus2 = Surplus(
      id: "2",
      userId: "user2",
      location: "location",
      name: "Ferramental",
      description:
          "Na próxima etapa todos os exedentes do tipo Ferramental serão listados",
      photos: ["image3.jpg"],
      category: "Ferramenta",
      units: "kg",
      date: DateTime.now().toString(),
    );
    final surplus3 = Surplus(
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

    // Convert Surplus objects to SurplusItem objects (assuming SurplusItem has a constructor that takes Surplus)
    final surplusItems = [surplus1, surplus2, surplus3];

    return surplusItems;
  }

// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (_) => AnnotationPage(),
// ),
// );
}
