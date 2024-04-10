import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

whichAnnouncementBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: BottomSheet(
        backgroundColor: Colors.white,
        builder: (context) => Column(
          children: [
            Text('Exemplo de texto'),
            // ... sua lista
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Fechar'),
                ),
                Text('Exemplo de texto no botão'),
              ],
            ),
          ],
        ), onClosing: () {  },
      ),
    ),
  );
}