import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/model/Announcement.dart';
import '../core/repository/AnnouncementRepository.dart';
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

  List<Announcement> _notes = [];

  late String user_id ;

  List<Announcement> get notes => _notes;
  String _apiKey = "";


  Future<void> deleteAllAnnouncements() async {
    await _announcementRepository.initialize();
    // await _announcementRepository.deleteAllAnnouncements();
  }

  Future<void> deleteAnnouncement(Announcement note) async {
    await _announcementRepository.initialize();
    // await _announcementRepository.deleteAnnouncement(note);
  }

  Future<void> _loadApiKey() async {
    await dotenv.load(fileName: '.env');
    _apiKey = dotenv.env['API_KEY']!;
  }
 void  _loadUserUID()  {
   user_id = authenticationService.getCurrentUuser_id();
  }

  Future<List<Announcement>> getAllAnnouncements() async {
    await _announcementRepository.initialize();
    // _notes = await _announcementRepository.getAllAnnouncements();
    return _notes;
    notifyListeners();
  }


  // Future<void> initialize() async {
  //   await _announcementRepository.initialize();
  // }

  Future<void> createNewAnnouncement(Announcement note, BuildContext context) async {
    await _announcementRepository.initialize();
    // await _announcementRepository.saveAnnouncement(note);
    await getAllAnnouncements();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  NavigationBarMain(),
      ),
    );
  }
}
