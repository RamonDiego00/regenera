import 'package:flutter/material.dart';

 whichSurplusBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => FractionallySizedBox(
    heightFactor: 0.8,
    child:Container(
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
    ),)
  );
}