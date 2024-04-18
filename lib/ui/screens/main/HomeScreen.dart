import 'package:flutter/material.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/core/repository/AnnouncementRepository.dart';
import 'package:regenera/viewmodel/AnnouncementViewModel.dart';
import 'package:regenera/ui/widgets/AnnouncementItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AnnouncementRepository announcementRepository;
  late AnnouncementViewModel announcementViewModel;
  bool _isToggled = false;
  Future<List<Announcement>>? _allAnnouncements;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    announcementRepository = AnnouncementRepository();
    announcementViewModel = AnnouncementViewModel(announcementRepository);
    _allAnnouncements = announcementViewModel.getAllAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          // Handle floating action button press
        },
        label: Text(
          "Mapa",
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        icon: Icon(
          Icons.map_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 320,
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  _allAnnouncements =
                                      announcementViewModel.searchAnnouncements(value);
                                });
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintText: 'Alimentos-Materiais-Sementes',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(127, 202, 69, 1),
                                  size: 30.0,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 12.0),
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                labelText: "O que você procura?",
                                labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            // Handle tap
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: FadeInImage(
                                placeholder: AssetImage('path/to/placeholder.png'),
                                image: NetworkImage(
                                  announcementViewModel.authenticationService.getProfileImageUrl()!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: Card(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    child: SizedBox(
                      width: 320.0,
                      height: 80.0,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mostrar descrição',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Inclui todos os detalhes dos itens',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isToggled,
                              onChanged: (value) => setState(() => _isToggled = value),
                              activeColor: Color.fromRGBO(127, 202, 69, 1),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Announcement>>(
                    future: _allAnnouncements,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Column(
                          children: [
                            SizedBox(height: 30.0),
                            Text('Erro ao carregar os itens'),
                          ],
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(height: 30.0),
                            Text('Não há itens disponíveis'),
                          ],
                        );
                      } else {
                        return Container(
                          constraints: BoxConstraints(maxWidth: 340),
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 28.0),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final announcement = snapshot.data![index];
                              return AnnouncementItem(announcement: announcement);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    _allAnnouncements = announcementViewModel.getAllAnnouncements();
    setState(() {});
  }
}
