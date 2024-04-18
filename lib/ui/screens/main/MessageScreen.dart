
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chats/ChatPage.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
              child: Text(
                "Mensagens",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: _buildUserList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Erro ao carregar usuários");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Nenhum usuário encontrado'),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final userEmail = data['email'] ?? 'Email não disponível';
    final userName = data['name'] ?? 'Nome não disponível';
    final userPhotoUrl = data['photoUrl'] ?? 'https://example.com/default.jpg';

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userPhotoUrl),
      ),
      title: Text(
        userName,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        userEmail,
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        final receiverUserEmail = data['email'];
        final receiverUserID = data['id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatPage(
                  receiverUserEmail: receiverUserEmail,
                  receiverUserID: receiverUserID,
                ),
          ),
        );
      },
    );
  }
}
