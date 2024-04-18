import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/ui/components/item/SurplusItem.dart';
import 'package:uuid/uuid.dart';

import '../core/repository/AnnouncementRepository.dart';
import '../core/repository/SurplusRepository.dart';
import '../model/Surplus.dart';
import '../services/authenticationService.dart';
import '../ui/components/bottombar/NavigationBarMain.dart';

class SurplusViewModel extends ChangeNotifier {
  final SurplusRepository _surplusRepository;
  final authenticationService = AuthenticationService();

  SurplusViewModel(this._surplusRepository) {
    _loadApiKey();
    _loadUserUID();
    _surplusRepository.initialize();
  }

  // File? _imageFile = null;
  // String _tempImagePath = "";
  List<Announcement> _notes = [];

  late String user_id;
  late List<String> myphotos;

  List<Announcement> get notes => _notes;
  String _apiKey = "";

  Future<void> deleteAllAnnouncements() async {
    await _surplusRepository.initialize();
    // await _surplusRepository.deleteAllAnnouncements();
  }

  Future<void> deleteAnnouncement(Announcement note) async {
    await _surplusRepository.initialize();
    // await _surplusRepository.deleteAnnouncement(note);
  }

  Future<void> _loadApiKey() async {
    await dotenv.load(fileName: '.env');
    _apiKey = dotenv.env['API_KEY']!;
  }

  void _loadUserUID() {
    user_id = authenticationService.getCurrentUuser_id();
  }

  Future<void> pickImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   _imageFile = File(pickedFile.path as List<Object>,"algo");
    //   _tempImagePath = await _getTemporaryPath();
    //   await _imageFile?.copy(_tempImagePath);
    //   setState(() {}); // Atualize o estado da interface
    // }
  }

  Future<List<Announcement>> getAllAnnouncements() async {
    await _surplusRepository.initialize();
    // _notes = await _surplusRepository.getAllAnnouncements();
    return _notes;
    notifyListeners();
  }

  Future<List<Surplus>> getOptionsSurplus() async {
    // Create two fictitious Surplus objects
    final surplus1 = Surplus(
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
    final surplus2 = Surplus(
      id: "2",
      userId: "user2",
      location: "location",
      name: "Ferramental",
      description: "Qualquer tipo de ferramental que seja útil para o plantio",
      photos: ["image3.jpg"],
      category: "Ferramenta",
      units: "kg",
      date: DateTime.now().toString(),
    );

    // Convert Surplus objects to SurplusItem objects (assuming SurplusItem has a constructor that takes Surplus)
    final surplusItems = [surplus1, surplus2];

    return surplusItems;
  }

  // Future<void> initialize() async {
  //   await _surplusRepository.initialize();
  // }


  Future<List<String>> pickImages() async {
    final picker = ImagePicker();
    final imageUrls = <String>[];

    // Capturar até 5 imagens da galeria
    try {
      final List<XFile>? pickedImages = await picker.pickMultiImage();

      if (pickedImages != null && pickedImages.isNotEmpty) {
        for (final XFile image in pickedImages) {
          // Obter arquivo da imagem
          final file = File(image.path);

          // Gerar nome de arquivo único
          final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

          // Referenciar o armazenamento do Firebase
          final storageRef = FirebaseStorage.instance.ref().child('imagens/$fileName');

          // Fazer upload do arquivo para o Firebase Storage
          await storageRef.putFile(file);

          // Obter a URL da imagem
          final imageUrl = await storageRef.getDownloadURL();

          // Armazenar a URL na lista **e** na variável _photos
          imageUrls.add(imageUrl);
          myphotos.add(imageUrl);
        }
      }
    } catch (error) {
      print('Erro ao selecionar ou fazer upload de imagens: $error');
    }

    return imageUrls;
  }


  Future<String> getImageUrlFromFirebase(String imagePath) async {
    try {
      // Referenciar o armazenamento do Firebase
      final storageRef = FirebaseStorage.instance.ref().child(imagePath);

      // Obter a URL da imagem
      final imageUrl = await storageRef.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print('Erro ao recuperar a imagem do Firebase Storage: $error');
      // Em caso de erro, retorne uma string vazia ou trate o erro de outra forma adequada
      return '';
    }
  }



  Future<void> createNewSurplus(
      String _name,
      String _description,
      List<String> _photos,
      String _units,
      String _location,
      String _category) async {
    await _surplusRepository.initialize();


    final uuid = Uuid();
    String id = uuid.v4();
    String date = DateTime.now().toString();


    final surplus = Surplus(
        id: id,
        userId: user_id,
        name: _name,
        location: _location,
        description: _description,
        photos: _photos,
        category: _category,
        units: _units,
        date: date);

    // receber todos os dados via paramertro
    // criar Id e capturar o UserId Aqui
    // criar surplus aqui

    _surplusRepository.saveSurplus(surplus);
  }


}
