import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:regenera/core/repository/AnnouncementRepository.dart';
import 'package:regenera/model/Announcement.dart';
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

  @override
  void initState() {
    super.initState();
    announcementRepository = AnnouncementRepository();
    announcementViewModel = AnnouncementViewModel(announcementRepository);

    surplus =
        announcementViewModel.getSurplusById(widget.announcement.surplusId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image carousel with heart icon
              Stack(
                alignment: Alignment.topRight,
                children: [
                  CarouselSlider.builder(
                    itemCount: 2, //length image,
                    itemBuilder: (context, index, carouselController) {
                      final imageURL = ["images"][index];
                      return Image.network(
                        imageURL,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200, // Adjust carousel height as needed
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
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              // Row with evaluation and location text
              Column(children: [
                FutureBuilder<Surplus>(
                    future: announcementViewModel
                        .getSurplusById(widget.announcement.surplusId),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(snapshot.data!.name),
                              TextButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.people),
                                  label: Text(widget.announcement.dealing))
                            ],
                          ),
                          Text("480  km de distancia"),
                          SizedBox(height: 20),
                          Text(snapshot.data!.units),
                        ],
                      );
                    }),
              ]),
              Column(
                children: [
                  FutureBuilder<Surplus>(
                      future: announcementViewModel
                          .getSurplusById(widget.announcement.surplusId),
                      builder: (context, snapshot) {
                        return Text(snapshot.data!.name);
                      })
                ],
              ),
// Column with distance and product quantity tex
              // ... (rest of the card content)
            ],
          ),
        ),
      ),
    );
  }
}
