import 'package:flutter/material.dart';
import 'package:regenera/model/Surplus.dart';

import '../../../core/repository/SurplusRepository.dart';
import '../../../viewmodel/SurplusViewModel.dart';

class SurplusItem extends StatefulWidget {
  final Surplus surplus;
  final Function(Surplus) onSurplusSelected;

  const SurplusItem({
    required this.surplus,
    required this.onSurplusSelected,
  });

  @override
  _SurplusItemState createState() => _SurplusItemState();
}

class _SurplusItemState extends State<SurplusItem> {
  late SurplusRepository surplusRepository;
  late SurplusViewModel surplusViewModel;
  bool _isSelected = false; // Adicionando um estado para controlar a seleção

  @override
  void initState() {
    super.initState();
    surplusRepository = SurplusRepository();
    surplusViewModel = SurplusViewModel(surplusRepository);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 150,
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        // Ajuste da borda com base no estado de seleção
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: _isSelected ? Colors.black : Colors.grey, // Cor da borda alterada quando selecionado
            width: _isSelected ? 2.0 : 1.0, // Espessura da borda alterada quando selecionado
          ),
        ),
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            // Atualize o estado de seleção quando o item for tocado
            setState(() {
              _isSelected = !_isSelected;
            });
            // Chame a função de retorno de chamada quando o item for selecionado
            widget.onSurplusSelected(widget.surplus);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        widget.surplus.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    // Container para os ícones condicionais
                    Container(
                      child: widget.surplus.category == "Comida"
                          ? Icon(
                        Icons.fastfood_outlined,
                        size: 32.0,
                        color: Colors.black,
                      )
                          : Icon(
                        Icons.hardware_outlined,
                        size: 32.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
                SizedBox(width: 5.0),
                Text(
                  widget.surplus.description,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
