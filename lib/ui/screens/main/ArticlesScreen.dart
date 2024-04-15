import 'package:flutter/material.dart';
import 'package:regenera/model/Announcement.dart';

import '../../../core/repository/AnnouncementRepository.dart';
import '../../../viewmodel/AnnouncementViewModel.dart';
import '../../widgets/AnnouncementItem.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key});

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late AnnouncementRepository announcementRepository;
  late AnnouncementViewModel announcementViewModel;

  @override
  void initState() {
    super.initState();

    announcementRepository = AnnouncementRepository();
    announcementViewModel = AnnouncementViewModel(announcementRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          child: Text(
                            "Artigos",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // Added loading indicator
                Align(
                  alignment: Alignment.center,
                  child: Expanded(
                    child: FutureBuilder<List<Announcement>>(
                      future: announcementViewModel
                          .getAllArticles(), // Updated method
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Loading indicator
                        } else if (snapshot.hasError) {
                          return Column(
                            children: [
                              SizedBox(height: 30.0),
                              Text('Erro ao carregar os artigos'),
                            ],
                          );
                        } else {
                          if (snapshot.data!.isEmpty) {
                            return const SizedBox(
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
                                    'Por aqui voces pode ler os artigos e encaminhar para alguns amigos e comerciantes.',
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
                                  final announcement = snapshot.data![index];
                                  return AnnouncementItem(
                                    announcement: announcement,
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
