import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:regenera/model/Announcement.dart';

import '../../../core/repository/AnnouncementRepository.dart';
import '../../../viewmodel/AnnouncementViewModel.dart';
import '../../widgets/AnnouncementItem.dart';
import 'PopUpUser.dart';

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

  // GoogleMapController _mapController;
  // Location _location = Location();
  // bool _locationPermissionGranted = false;
  // LatLng _currentLocation;
  // List<Marker> _markers = [];


  Future<void> _refreshList() async {
    _allAnnouncements = announcementViewModel.getAllAnnouncements();
    setState(() {
      _allAnnouncements;
    });
  }

  Future<void> _getUserLocation() async {
    // Position posicao = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // setState(() {
    //   _userLocation = LatLng(posicao.latitude, posicao.longitude);
    // });
  }

  Future<void> _searchNextUsers() async {
    // Busque usuários da sua fonte de dados (substitua pela sua implementação)
    // List<User> users = await buscarUsuariosProximosDeApiOuBancoDeDados();
    setState(() {
      // _usersNext = users;
    });
  }

  void _openMap() async {
    // Crie marcadores para usuários próximos
    // List<Marker> marcadores = _usersNext.map((user) {
    //   return Marker(
    //     markerId: MarkerId(user.uid),
    //     // position: LatLng(user.latitude, user.longitude),
    //     infoWindow: InfoWindow(title: user.displayName),
    //   );
    // }).toList();

    // Defina marcadores e centralize o mapa na localização do usuário
    // await _controleMapa.showMarkers(marcadores);
    // await _controleMapa.animateCamera(CameraUpdate.newCameraPosition(
    //     CameraPosition(target: _userLocation, zoom: 12)));
  }


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
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          onPressed: () {
            _openMap();
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
              builder: (context) =>
                  Center(
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
                                        borderRadius: BorderRadius.circular(
                                            40.0),
                                      ),
                                      child: TextField(
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                            ),
                                            hintText:
                                            'Alimentos-Materiais-Sementes',
                                            prefixIcon: const Icon(
                                              Icons.search,
                                              color:
                                              Color.fromRGBO(127, 202, 69, 1),
                                              size: 30.0,
                                            ),
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 12.0),
                                            hintStyle: TextStyle(
                                              color: Colors.black.withOpacity(
                                                  0.5),
                                            ),
                                            labelText: "O que você proura ?",
                                            labelStyle: TextStyle(
                                              color: Colors.black.withOpacity(
                                                  0.5),
                                            )),
                                      ),
                                    )),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return LogoutPopup();
                                      },
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: FadeInImage(
                                        placeholder: AssetImage(
                                            'path/to/placeholder.png'),
                                        image: NetworkImage(
                                            announcementViewModel
                                                .authenticationService
                                                .getProfileImageUrl()!),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            'Inclui todos os detalhes dos items',
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
                                      onChanged: (value) =>
                                          setState(() => _isToggled = value),
                                      activeColor:
                                      Color.fromRGBO(127, 202, 69, 1),
                                      materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
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
                            // Recupera todas as notas
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Text('Erro ao carregar as notas')
                                  ],
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data!.isEmpty) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Text('Não temos nada dessa categoria')
                                  ],
                                );
                              } else {
                                // Mapeie cada nota para um widget NoteItem
                                return Container(
                                  constraints: BoxConstraints(maxWidth: 340),
                                  // Define a largura máxima da lista
                                  child: ListView.builder(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 28.0),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final announcement =
                                      snapshot.data![index];
                                      return AnnouncementItem(
                                          announcement: announcement,);
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
        ));
  }
}

// Container(
// width: 10,
// height: 10,
// margin: EdgeInsets.all(8),
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// image: DecorationImage(
// fit: BoxFit.cover,
// image: NetworkImage(
// announcementViewModel
//     .authenticationService
//     .getProfileImageUrl()!)),
// ),
// )
