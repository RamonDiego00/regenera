import 'package:flutter/material.dart';
import 'package:regenera/viewmodel/AnnouncementViewModel.dart';
import 'package:regenera/viewmodel/SurplusViewModel.dart';

import '../../viewmodel/ArticleViewModel.dart';
import 'createAnnouncement.dart';
import 'createArticle.dart';
import 'createSurplus.dart';

class Handle {
  void handleCreateSurplus(BuildContext context,SurplusViewModel surplusViewModel,ArticleViewModel articleViewModel ,AnnouncementViewModel announcementViewModel) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(

            height: MediaQuery.of(context).size.height * 0.4,
            child: BottomSheet(
              backgroundColor: Colors.white,
              builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  SurplusSheet().whichSurplusBottomSheet(context, surplusViewModel);
                                },
                                child: SizedBox(
                                  height: 100.0,
// Altura da Row
                                  width: 100.0,
// Largura da Row
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        color: Colors.black,
                                        Icons.handyman_rounded,
                                        size: 26,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Criar Excedente',
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ]),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    AnnouncementSheet().whichAnnouncementBottomSheet(context, announcementViewModel);
                                  },
                                  child: SizedBox(
                                    height: 100.0,
// Altura da Row
                                    width: 100.0,
// Largura da Row
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          color: Colors.black,
                                          Icons.speaker_phone,
                                          size: 26,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Criar Anuncio',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Divider(),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    createArticleBottomSheet(context);
                                  },
                                  child: SizedBox(
                                    height: 100.0,
// Altura da Row
                                    width: 100.0,
// Largura da Row
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          color: Colors.black,
                                          Icons.menu_book_sharp,
                                          size: 26,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Criar Artigo',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Divider(),
                          ],
                        )
                      ],
                    ))
                  ]),
              onClosing: () {},
            )));
  }
}
