import 'package:flutter/material.dart';
import 'package:regenera/model/Article.dart';

import '../../../core/repository/ArticleRepository.dart';
import '../../../model/Article.dart';
import '../../../viewmodel/ArticleViewModel.dart';

class ArticleItem extends StatefulWidget {
  final Article article;

  const ArticleItem({
    required this.article,
  }) ;

  @override
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
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
    print("Mano tem");
    return Container(
        constraints: BoxConstraints(maxWidth: 340),
        child:  Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        // Set background color to white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side:
          BorderSide(color: Colors.black, width: 1.0), // Thin black border
        ),
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {

          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        widget.article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
                SizedBox(width: 5.0),
                Text(widget.article.description,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black))
              ],
            ),
          ),
      ),
    )
    );
  }
}
