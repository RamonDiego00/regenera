import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/utils/bottomSheet/createSurplus.dart';
import 'package:uuid/uuid.dart';
import '../core/repository/AnnouncementRepository.dart';
import '../model/Surplus.dart';
import '../services/authenticationService.dart';
import '../ui/components/bottombar/NavigationBarMain.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementRepository _announcementRepository;
  final authenticationService = AuthenticationService();

  AnnouncementViewModel(this._announcementRepository) {
    _loadApiKey();
    _loadUserUID();
    _announcementRepository.initialize();
  }

  List<Announcement> _announcement = [];

  late String user_id;

  List<Announcement> get notes => _announcement;
  String _apiKey = "";

  createNewAnnouncement(Surplus surplus) {
    final uuid = Uuid();
    String id = uuid.v4();
    final newAnnouncement = Announcement(
        id: id, surplusId: surplus.id, dealing: "0", negotiated: false);
    _announcementRepository.initialize();
    _announcementRepository.saveAnnouncement(newAnnouncement);
  }

  deleteAnnouncement(Announcement note) {
    _announcementRepository.initialize();
    // await _announcementRepository.deleteAnnouncement(note);
  }

  Future<List<Announcement>> getAllAnnouncements() async {
    _announcementRepository.initialize();
    _announcement = await _announcementRepository.getAllAnnouncements();
    return _announcement;
    notifyListeners();
  }

  Future<List<Surplus>> getOptionsAnnouncement() async {
    // Create two fictitious Surplus objects
    final surplus1 = Surplus(
      id: "1",
      userId: "user1",
      location: "location",
      name: "Alimentício",
      description:
          "Na próxima etapa todos os exedentes do tipo alimentício serão listados",
      photos: ["image1.jpg,image2.jpg"],
      category: "Comida",
      units: "kg",
      date: DateTime.now().toString(),
    );
    final surplus2 = Surplus(
      id: "2",
      userId: "user2",
      location: "location",
      name: "Ferramental",
      description:
          "Na próxima etapa todos os exedentes do tipo Ferramental serão listados",
      photos: ["image3.jpg"],
      category: "Ferramenta",
      units: "kg",
      date: DateTime.now().toString(),
    );
    final surplus3 = Surplus(
      id: "3",
      userId: "user2",
      location: "location",
      name: "Serviço",
      description:
          "Qualquer tipo de serviço que ajude o plantio ou manutenção dos jardins",
      photos: ["image3.jpg"],
      category: "Ferramenta",
      units: "kg",
      date: DateTime.now().toString(),
    );

    // Convert Surplus objects to SurplusItem objects (assuming SurplusItem has a constructor that takes Surplus)
    final surplusItems = [surplus1, surplus2, surplus3];

    return surplusItems;
  }

  Future<List<Surplus>> getMyAllSurplusByCategory(String category) async {
    return await _announcementRepository.getMyAllSurplusByCategory(category);
  }

  Future<Surplus> getSurplusById(String surplusId) async {
    await _announcementRepository.initialize();
    return Surplus(
      id: "1",
      userId: "user1",
      location: "location",
      name: "Alimentício",
      description: "Qualquer tipo de alimento ue sido plantado e colhido",
      photos: ["image1.jpg,image2.jpg"],
      category: "Comida",
      units: "kg",
      date: DateTime.now().toString(),
    );
    // await _announcementRepository.deleteAnnouncement(note);
  }

  Future<void> _loadApiKey() async {
    await dotenv.load(fileName: '.env');
    _apiKey = dotenv.env['API_KEY']!;
  }

  void _loadUserUID() {
    user_id = authenticationService.getCurrentUuser_id();
  }

  Future<List<Announcement>> getAllArticles() async {
    await _announcementRepository.initialize();
    // _announcement = await _announcementRepository.getAllAnnouncements();
    return _announcement;
    notifyListeners();
  }

  Future<List<Announcement>> getAllFavoriteAnnouncements() async {
    await _announcementRepository.initialize();
    // _announcement = await _announcementRepository.getAllAnnouncements();
    return _announcement;
    notifyListeners();
  }

// Future<void> initialize() async {
//   await _announcementRepository.initialize();
// }
}
