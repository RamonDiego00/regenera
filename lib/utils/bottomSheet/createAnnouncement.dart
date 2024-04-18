import 'package:flutter/material.dart';
import 'package:regenera/viewmodel/AnnouncementViewModel.dart';
import 'package:regenera/viewmodel/SurplusViewModel.dart';

import '../../model/Surplus.dart';
import '../../ui/components/bottombar/NavigationBarMain.dart';
import '../../ui/components/item/SurplusItem.dart';
import '../../viewmodel/ArticleViewModel.dart';

class AnnouncementSheet extends ChangeNotifier {
  String _category = 'Comida';
  late Surplus _selectedSurplus;

  whichAnnouncementBottomSheet(
      BuildContext context, AnnouncementViewModel announcementViewModel) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.8,
              child: Container(
                child: BottomSheet(
                  backgroundColor: Colors.white,
                  builder: (context) => Column(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 20.0),
                              // Ajuste os valores de padding como necessário
                              child: Column(
                                children: [
                                  SizedBox(
                                      child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                              'Qual categoria se enquadra o seu anúncio?',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black))),
                                      height: 120,
                                      width: 250),
                                  Expanded(
                                    child: FutureBuilder<List<Surplus>>(
                                      future: announcementViewModel
                                          .getOptionsAnnouncement(),
                                      builder: (context, snapshot) {
                                        print(snapshot.data?.length);

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 30.0,
                                              ),
                                              Text(
                                                  'Erro ao carregar os excedentes')
                                            ],
                                          );
                                        } else if (snapshot.hasData &&
                                            snapshot.data!.isEmpty) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 30.0,
                                              ),
                                              Text('Nenhum exedente encontrado')
                                            ],
                                          );
                                        } else {
                                          return Container(
                                            child: ListView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 28.0),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                final surplus =
                                                    snapshot.data![index];
                                                return SurplusItem(
                                                  surplus: surplus,
                                                  onSurplusSelected:
                                                      (selectedSurplus) {},
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Voltar",
                                  style: TextStyle(color: Colors.black),
                                )),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                definingSurplusBottomSheet(
                                    context, announcementViewModel);

                                // fazer tratamento de clique
                                _category = "Comida";
                              },
                              child: Text(
                                'Avançar',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  onClosing: () {},
                ),
              ),
            ));
  }

  definingSurplusBottomSheet(
      BuildContext context, AnnouncementViewModel announcementViewModel) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
            heightFactor: 0.8,
            child: Container(
              child: BottomSheet(
                backgroundColor: Colors.white,
                builder: (context) => Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                            // Adiciona SingleChildScrollView
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20.0),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 20.0),
                                // Ajuste os valores de padding como necessário
                                child: Column(
                                  children: [
                                    const SizedBox(
                                        width: 320,
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                Text(
                                                    'Qual desses exedentes voce quer anunciar?',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black)),
                                              ],
                                            ))),
                                    FutureBuilder<List<Surplus>>(
                                      future: announcementViewModel
                                          .getMyAllSurplusByCategory(_category),
                                      // Recupera todas os tipos
                                      builder: (context, snapshot) {
                                        print(snapshot.data?.length);

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 30.0,
                                              ),
                                              Text(
                                                  'Erro ao carregar os excedentes')
                                            ],
                                          );
                                        } else if (snapshot.hasData &&
                                            snapshot.data!.isEmpty) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 30.0,
                                              ),
                                              Text('Nenhum exedente encontrado')
                                            ],
                                          );
                                        } else {
                                          return Container(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 28.0),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                final surplus =
                                                    snapshot.data![index];
                                                return SurplusItem(
                                                    surplus: surplus,
                                                    onSurplusSelected:
                                                        (selectedSurplus) => {
                                                              _selectedSurplus = selectedSurplus
                                                            });
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                )))),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Voltar",
                                style: TextStyle(color: Colors.black),
                              )),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              announcementViewModel
                                  .createNewAnnouncement(_selectedSurplus);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NavigationBarMain(),
                                  ),
                                  (Route<dynamic> route) => route.isFirst);
                            },
                            child: Text(
                              'Confirmar',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                onClosing: () {},
              ),
            )));
  }
}
