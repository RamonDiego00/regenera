import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/repository/UserRepository.dart';
import '../main.dart';
import '../model/User.dart';
import '../viewmodel/UserViewModel.dart';

class AuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final UserRepository _userRepository = UserRepository();
  UserViewModel? _userViewModel;

  late String _userUid;
  late GoogleSignInAccount? gUser = null;

  String getCurrentUuser_id() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      _userUid = user.uid;
      return _userUid;
    } else {
      return "";
    }
  }

  void _initializeUserViewModel() {
    _userViewModel = UserViewModel(_userRepository);
  }

  String? getProfileImageUrl() {
    if (_firebaseAuth.currentUser?.photoURL != null) {
      return _firebaseAuth.currentUser!.photoURL!;
    } else {
      return null;
    }
  }
  Future<User?> getUserById(String? userId) async {
    final cloud = FirebaseFirestore.instance;

    try {
      final collectionReference = cloud.collection("users");
      final querySnapshot = await collectionReference
          .where('id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // Usuário não encontrado
      }

      final userData = querySnapshot.docs.first.data();
      final user = User.fromMap(userData);
      return user;

    } catch (e) {
      print('Erro ao recuperar usuário: $e');
      return null;
    }
  }


  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {

      _initializeUserViewModel();

      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return null;
      }
      this.gUser = gUser;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken,
        accessToken: gAuth.accessToken,
      );

      final UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // salvando o user no banco de dados local e remoto

      User user = User(
          id: gUser.id,
          name: gUser.displayName!,
          email: gUser.email,
          password: "",
          garden: '',
          location: '',
          dimension: '',
          age: '',
          plantations: '');

      _userViewModel?.registerUser(context, user);

      if (userCredential != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
      return userCredential;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<String?> registerUser({
    required BuildContext context,
    required String name,
    required String password,
    required String email,
  }) async {
    try {
      _initializeUserViewModel();

      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // dá pra pegar várias informações do usuário e até colocar nome
      await user.user!.updateDisplayName(name);

      // salvando remotamente no firestore como uma collection (ideal é mover para um outro arquivo essa lógica)

      User userCloud = User(
          id: user.user!.uid,
          name: name,
          email: email,
          password: password,
          garden: '',
          location: '',
          dimension: '',
          age: '',
          plantations: '');

      _userViewModel?.registerUser(context, userCloud);

      // final User newUser = User(name: name, email: email, password: password, id: user.user!.uid);
      // // _userViewModel!.registerUser(context, newUser);
      //
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.user?.uid)
      //     .set(newUser.toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "email-already-in-use") {
        return "O email já esta em uso";
      }

      return "Erro desconhecido";
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "wrong-password") {
        return "Senha incorreta";
      } else if (e.code == "user-not-found") {
        return "Usuário não encontrado";
      }

      return "Erro desconhecido";
    }
  }

  deleteUser({
    required String password,
    required String email,
  }) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    // dá pra pegar várias informações do usuário e até colocar nome
    // await user.user!.updateDisplayName("displayName");
  }

  updateUser({
    required String password,
    required String email,
  }) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    // dá pra pegar várias informações do usuário e até colocar nome
    // await user.user!.updateDisplayName("displayName");
  }
}
