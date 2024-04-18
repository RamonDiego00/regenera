import 'package:flutter/material.dart';
import 'package:regenera/viewmodel/SurplusViewModel.dart';

import '../../model/Surplus.dart';
import '../../ui/components/bottombar/NavigationBarMain.dart';
import '../../ui/components/item/SurplusItem.dart';

class SurplusSheet extends ChangeNotifier {
  String _name = '';
  String _description = '';
  String _location = '';
  List<String> _photos = [];
  String _category = '';
  String _units = '';
  String _date = '';

  locationSurplusBottomSheet(
      BuildContext context, SurplusViewModel surplusViewModel) {
    TextEditingController _locationController = TextEditingController();
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
                                  const SizedBox(
                                      child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Column(
                                            children: [
                                              Text(
                                                  'Me fale a localização do seu jardim',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black)),
                                              Text(
                                                  'Seu endereço irá ajudar a fazer trocas mais eficientes e próximas do seu jardim',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black54))
                                            ],
                                          )),
                                      width: 320),
                                  Material(
                                    elevation: 4,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: TextField(
                                      controller: _locationController,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          hintText: 'Buscar',
                                          prefixIcon: const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.black,
                                            size: 30.0,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 15.0),
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          labelStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          )),
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
                                infoSurplusBottomSheet(
                                    context, surplusViewModel);

                                _location = _locationController.text;
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

  whichSurplusBottomSheet(
      BuildContext context, SurplusViewModel surplusViewModel) {
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
                                              'Qual categoria se enquadra o seu exedente?',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black))),
                                      height: 120,
                                      width: 250),
                                  Expanded(
                                    child: FutureBuilder<List<Surplus>>(
                                      future:
                                          surplusViewModel.getOptionsSurplus(),
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 28.0),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                final surplus =
                                                    snapshot.data![index];
                                                return SurplusItem(
                                                    surplus: surplus,
                                                  onSurplusSelected: (Surplus ) {  },);
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
                                locationSurplusBottomSheet(
                                    context, surplusViewModel);

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

  infoSurplusBottomSheet(
      BuildContext context, SurplusViewModel surplusViewModel) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _unitsController = TextEditingController();
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
                                                    'Compartilhe algumas informações básicas do item',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black)),
                                                Text(
                                                    'A quantidade sempre vai ser em quilogramas',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54))
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
                                            controller:_nameController ,
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
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          child: TextField(
                                            controller: _descriptionController,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                hintText: 'Descrição',
                                                prefixIcon: const Icon(
                                                  Icons.description_outlined,
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
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          child: TextField(
                                            controller: _unitsController,
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                hintText: 'Unidades',
                                                prefixIcon: const Icon(
                                                  Icons
                                                      .production_quantity_limits_outlined,
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 12.0),
                                          child: Text(
                                            "Adicione todas as fotos que detalhem o seu item Adicione todas as fotos que detalhem o seu item ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 12.0),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child:SizedBox(
                                              width: 140,
                                              height: 140,
                                              child: Card(
                                                surfaceTintColor: Colors.white,
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  side: BorderSide(color: Colors.black, width: 1.0),
                                                ),
                                                elevation: 4,
                                                margin: EdgeInsets.all(8),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    final urls = await surplusViewModel.pickImages();
                                                      _photos = urls;

                                                  },
                                                  child: Icon(Icons.add_circle_outline_rounded),
                                                ),
                                              ),
                                            )
                                            ,
                                          ),
                                        )
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
                              _name = _nameController.text;
                              _description = _descriptionController.text;
                              _units = _unitsController.text;

                              surplusViewModel.createNewSurplus(
                                _name,
                                _description,
                                _photos,
                                _units,
                                _location,
                                _category,
                              );

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NavigationBarMain(),
                                  ),
                                  (Route<dynamic> route) => route.isFirst);
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
            )));
  }
}
