import 'package:flutter/material.dart';
import 'package:regenera/model/Article.dart';
import 'package:regenera/core/repository/ArticleRepository.dart';
import 'package:regenera/viewmodel/ArticleViewModel.dart';
import '../../components/item/ArticleItem.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key});

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late ArticleRepository articleRepository;
  late ArticleViewModel articleViewModel;

  @override
  void initState() {
    super.initState();
    articleRepository = ArticleRepository();
    articleViewModel = ArticleViewModel(articleRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  child: Text(
                    "Artigos",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Added loading indicator
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: articleViewModel.getAllArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(), // Loading indicator
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar os artigos'),
                    );
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return SizedBox(
                        width: 320,
                        child: Column(
                          children: [
                            SizedBox(height: 50.0),
                            Text(
                              "Fique sempre atento a novos artigos pois eles podem te ajudar no seu plantio e cultivo ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Por aqui você pode ler os artigos e encaminhar para alguns amigos e comerciantes.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        constraints: BoxConstraints(maxWidth: 340),
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 28.0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            print("Caiu aqui");
                            return ArticleItem(
                              article: snapshot.data![index],
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
