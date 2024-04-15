import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regenera/model/Announcement.dart';

class AnnouncementDetailScreen extends StatefulWidget {


  final Announcement announcement;


  const AnnouncementDetailScreen({
    required this.announcement,
  });

  @override _AnnouncementDetailScreenState createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {

  // late SurplusRepository surplusRepository;
  // late SurplusViewModel surplusViewModel;

  @override
  void initState() {
    super.initState();
    // surplusRepository = SurplusRepository();
    // surplusViewModel = SurplusViewModel(surplusRepository);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Detalhes do Produto'),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagem do Produto
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 3,
            color: Colors.grey, // Cor de fundo temporária
            child: Image.network(
              'url_da_imagem_do_produto',
              fit: BoxFit.cover,
            ),
          ),
          // Título do Item
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nome do Produto',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Localização
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Localização: Local do Produto',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          // Nome de quem criou
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Criado por: Nome do Criador',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          // Descrição do Produto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Descrição do Produto...',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Quantidade do Produto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Quantidade: X',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          // Botão "Trocar"
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Implemente a navegação para a outra tela aqui
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text('Trocar'),
            ),
          ),
        ],
      ),
    ),
  );
}


}