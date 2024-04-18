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
  late User1.User _user;
  List<String> imageUrls = [];

  Future<void> _loadSurplus() async {
    Surplus? surplus = await widget.surplus;
    _surplus = surplus;
    setState(() {
      _surplus = surplus;
      _getUserSurplus(surplus.userId);
    });
  }

  Future<void> _getUserSurplus(String userId) async {
    User1.User? user = await AuthenticationService().getUserById(userId);
    setState(() {
      if (user != null) {
        _user = user;
      }
    });
  }

  Future<void> _loadRandomImages() async {
    final ListResult result =
    await FirebaseStorage.instance.ref('imagens/').listAll();

    final List<String> urls = [];
    await Future.forEach(result.items, (Reference ref) async {
      final url = await ref.getDownloadURL();
      urls.add(url);
    });

    setState(() {
      imageUrls = urls;
    });
  }

  @override
  void initState() {
    super.initState();
    _user = User1.User(id: '', name: '', email: '', garden: '', location: '', dimension: '', age: '', plantations: '', password: ''); // Initialize user object
    _loadSurplus();
    _loadRandomImages();
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.grey,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  CarouselSlider.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index, carouselController) {
                      if (index >= imageUrls.length) {
                        return Container(); // Return an empty container if index is invalid
                      }
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
              ),
            ),
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
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Divider(),
                  Text(
                    "Criado por: ${_user.email}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Divider()
                ],
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              receiverUserEmail: _user.email.toString(),
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
