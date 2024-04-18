import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/ui/screens/chats/ChatPage.dart';


import '../../../model/Surplus.dart';
import '../../../model/User.dart' as User1;
import '../../../services/authenticationService.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;
  final Future<Surplus> surplus;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
    required this.surplus,
  });

  @override
  _AnnouncementDetailScreenState createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  late Surplus? _surplus;
  late User1.User? _user;
  List<String> imageUrls = [];

  // late SurplusRepository surplusRepository;
  // late SurplusViewModel surplusViewModel;



  Future<void> _loadSurplus() async {
    _surplus = await widget.surplus;
    setState(() {});
  }
   Future<void> _getUserSurplus() async {
    _user = await  AuthenticationService().getUserById(_surplus?.userId);

  }



  Future<void> _loadRandomImages() async {
    // Recupera as referências de todas as imagens no seu armazenamento do Firebase
    final ListResult result =
        await FirebaseStorage.instance.ref('imagens/').listAll();

    // Extrai as URLs de todas as imagens
    final List<String> urls = [];
    await Future.forEach(result.items, (Reference ref) async {
      final url = await ref.getDownloadURL();
      urls.add(url);
    });

    urls.shuffle();

    setState(() {
      imageUrls = urls;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserSurplus();
    _loadSurplus();
    _loadRandomImages();
    // surplusRepository = SurplusRepository();
    // surplusViewModel = SurplusViewModel(surplusRepository);
  }

  @override
  Widget build(BuildContext context) {
    // tirar o susplus do future e capturar a insatncia aqui

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Anuncio',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do Produto
            Container(
                height: MediaQuery.of(context).size.height / 3,
                color: Colors.grey, // Cor de fundo temporária
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CarouselSlider.builder(
                      itemCount: imageUrls.length, //length image,
                      itemBuilder: (context, index, carouselController) {
                        final imageURL = imageUrls[index];
                        return Image.network(
                          imageURL,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 400,
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 0.8,
                        // Adjust carousel viewport size
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        pauseAutoPlayOnTouch: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle heart icon tap (e.g., toggle favorite status)
                      },
                    ),
                  ],
                )),
            // Título do Item
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _surplus!.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            // Localização
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _surplus!.location,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            // Nome de quem criou
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Divider(),
                  Text(
                    "Criado por: ${FirebaseAuth.instance.currentUser?.email.toString()}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Divider()
                ],
              ),
            ),
            // Descrição do Produto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _surplus!.description,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                " ${_surplus!.name + _surplus!.units} kg",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            // Botão "Trocar"
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              receiverUserEmail: _user?.email.toString(),
                              receiverUserID: _surplus!.userId)));
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(127, 202, 69, 1),
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
