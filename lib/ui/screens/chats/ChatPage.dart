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
      appBar: AppBar(title: Text(widget.receiverUserEmail?.toString() ?? '')),
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
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      return SizedBox(); // Retorna um widget vazio se os dados forem nulos
    }

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    String senderEmail = data['senderEmail'] ?? 'Email não disponível';

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
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
