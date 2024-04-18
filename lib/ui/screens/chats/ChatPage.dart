import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regenera/services/chat/ChatService.dart';
import 'package:regenera/ui/widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String? receiverUserEmail;
  final String receiverUserID;

  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail?.toString() ?? 'Vazio')),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 25)
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        _firebaseAuth.currentUser!.uid,
        widget.receiverUserID,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

        return ListView.builder(
          itemCount: querySnapshot.size,
          itemBuilder: (context, index) {
            DocumentSnapshot documentSnapshot = querySnapshot.docs[index];

            // Passa o DocumentSnapshot para _buildMessageItem
            return _buildMessageItem(documentSnapshot);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    // Extrai os dados do DocumentSnapshot
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    // Implementação do restante do widget
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    String senderEmail = data['senderEmail'] ?? 'Email não disponível';

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(senderEmail),
            const SizedBox(height: 5),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }


  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }




  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Cor de fundo
          borderRadius: BorderRadius.circular(20.0), // Borda arredondada
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Sombra
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2), // Mudança de deslocamento da sombra
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: _messageController,
                  style: TextStyle(color: Colors.black), // Cor do texto
                  decoration: InputDecoration(
                    hintText: 'Digite sua mensagem', // Texto de dica
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none, // Remover borda padrão
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Color.fromRGBO(127, 202, 69, 1), // Cor do ícone
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

}
