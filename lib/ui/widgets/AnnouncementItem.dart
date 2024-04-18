import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:regenera/core/repository/AnnouncementRepository.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/ui/screens/details/AnnouncementDetailsScreen.dart';
import 'package:regenera/viewmodel/AnnouncementViewModel.dart';

import '../../model/Surplus.dart';

class AnnouncementItem extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementItem({required this.announcement});

  @override
  _AnnouncementItemState createState() => _AnnouncementItemState();
}

class _AnnouncementItemState extends State<AnnouncementItem> {
  late AnnouncementRepository announcementRepository;
  late AnnouncementViewModel announcementViewModel;
  late Future<Surplus> surplus;
  bool isFavorite = false;
  List<String> imageUrls = [];

  Future<void> loadRandomImages() async {
    final List<String> urls = [];
    try {
      final ListResult result = await FirebaseStorage.instance.ref('imagens/').listAll();
      await Future.forEach(result.items, (Reference ref) async {
        final url = await ref.getDownloadURL();
        urls.add(url);
      });
      urls.shuffle();
      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      print("Error loading images: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    announcementRepository = AnnouncementRepository();
    announcementViewModel = AnnouncementViewModel(announcementRepository);
    loadRandomImages();
    surplus = announcementViewModel.getSurplusById(widget.announcement.surplusId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementDetailScreen(
              announcement: widget.announcement,
              surplus: surplus,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
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
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<Surplus>(
                    future: announcementViewModel.getSurplusById(widget.announcement.surplusId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data!.location,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.people,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    widget.announcement.dealing,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "3 km de distância de você",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  snapshot.data!.units,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  " de ${snapshot.data!.name}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: announcementViewModel.showDescription,
                              // Condição para exibir a Row
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
