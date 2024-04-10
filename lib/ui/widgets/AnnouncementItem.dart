import 'package:flutter/material.dart';
import 'package:regenera/core/repository/AnnouncementRepository.dart';
import 'package:regenera/model/Announcement.dart';
import 'package:regenera/viewmodel/AnnouncementViewModel.dart';

class AnnouncementItem extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementItem({required this.announcement});

  @override
  _AnnouncementItemState createState() => _AnnouncementItemState();
}

class _AnnouncementItemState extends State<AnnouncementItem> {
  late AnnouncementRepository announcementRepository;
  late AnnouncementViewModel announcementViewModel;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    announcementRepository = AnnouncementRepository();
    announcementViewModel = AnnouncementViewModel(announcementRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(57, 57, 57, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.white54, // Altere a cor aqui
          width: 2,
        ),
      ),
      elevation: 4,
      // Ajusta a elevação do card
      margin: EdgeInsets.all(8),
      // Margem ao redor do card
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.announcement.negotiated,
                      style: Theme.of(context).textTheme.titleLarge
                    ),
                  ),
                  if (_isExpanded)
                    GestureDetector(
                      onTap: () {
                        announcementRepository.deleteNote(widget.announcement);
                      },
                      child: Icon(
                        Icons.delete,
                        size: 20,
                      ),
                    ),
                  SizedBox(width: 10),
                ],
              ),
              if (_isExpanded)
                Wrap(
                  children: [
                    Text(
                      widget.announcement.dealing,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
