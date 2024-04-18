import 'package:flutter/material.dart';
import 'package:regenera/viewmodel/ArticleViewModel.dart';
import '../../model/Surplus.dart';
import '../../ui/components/bottombar/NavigationBarMain.dart';
import '../../ui/components/item/SurplusItem.dart';

class ArticlesSheet extends ChangeNotifier {
  String _category = 'Comida';
  late Surplus _selectedSurplus;

  whichArticleBottomSheet(
      BuildContext context, ArticleViewModel articleViewModel) {
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
                                  future: articleViewModel.getOptionsArticle(),
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
                                context, articleViewModel);

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
      BuildContext context, ArticleViewModel articleViewModel) {

    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

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
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                Text(
                                                    'Escreva o seu artigo',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Colors.black))
                                              ],
                                            )),
                                        width: 320),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 4,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(40.0),
                                          ),
                                          child: TextField(
                                            style: TextStyle(color: Colors.black),
                                            controller:_titleController ,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20.0),
                                                ),
                                                hintText: 'Nome',
                                                prefixIcon: const Icon(
                                                  Icons
                                                      .drive_file_rename_outline_outlined,
                                                  color: Colors.black,
                                                  size: 20.0,
                                                ),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 12.0),
                                                hintStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                labelStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                )),
                                          ),
                                        ),
                                        Material(
                                          elevation: 4,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: TextFormField(
                                            controller: _descriptionController,
                                            cursorColor: Colors.black,
                                            maxLines: null, // Allows for multiple lines
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                                hintText: 'Unidades',
                                                prefixIcon: const Icon(
                                                  Icons.newspaper,
                                                  color: Colors.black,
                                                  size: 20.0,
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 12.0),
                                                hintStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                ),
                                                labelStyle: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                )),
                                          ),
                                        ),
                                      ],
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
                              articleViewModel.createNewArticle(_titleController.text,_descriptionController.text, _category);

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
