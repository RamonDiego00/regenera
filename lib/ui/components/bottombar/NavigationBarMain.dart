import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regenera/core/repository/ArticleRepository.dart';
import 'package:regenera/core/repository/SurplusRepository.dart';
import 'package:regenera/core/repository/UserRepository.dart';
import 'package:regenera/ui/screens/main/ArticlesScreen.dart';
import 'package:regenera/ui/screens/main/FavoriteScreen.dart';
import 'package:regenera/ui/screens/main/HomeScreen.dart';
import 'package:regenera/ui/screens/main/LoginScreen.dart';

import '../../../core/repository/AnnouncementRepository.dart';
import '../../../utils/bottomSheet/createAnnouncement.dart';
import '../../../utils/bottomSheet/handleCreateBottomSheet.dart';
import '../../../utils/bottomSheet/createArticle.dart';
import '../../../utils/bottomSheet/createSurplus.dart';
import '../../../viewmodel/AnnouncementViewModel.dart';
import '../../../viewmodel/ArticleViewModel.dart';
import '../../../viewmodel/SurplusViewModel.dart';
import '../../screens/main/MessageScreen.dart';

class NavigationBarMain extends StatefulWidget {
  @override
  _NavigationBarMainState createState() => _NavigationBarMainState();
}

class _NavigationBarMainState extends State<NavigationBarMain> {
  late SurplusRepository surplusRepository;
  late SurplusViewModel surplusViewModel;

  late ArticleRepository articleRepository;
  late ArticleViewModel articleViewModel;

 late AnnouncementRepository announcementRepository;
  late AnnouncementViewModel announcementViewModel;

  @override
  void initState() {
    super.initState();
    surplusRepository = SurplusRepository();
    surplusViewModel = SurplusViewModel(surplusRepository);

    articleRepository = ArticleRepository();
    articleViewModel = ArticleViewModel(articleRepository);

    announcementRepository = AnnouncementRepository();
    announcementViewModel = AnnouncementViewModel(announcementRepository);
  }



  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    // deve ser vazio
    const HomeScreen(),
    // esse homeScreen nã deve existir
    const MessageScreen(),
    const ArticlesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        Handle().handleCreateSurplus(context, surplusViewModel,articleViewModel,announcementViewModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: Color.fromRGBO(127, 202, 69, 1),
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            label: "Explorar",
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: "Favoritos",
            icon: Icon(Icons.favorite_border_rounded),
          ),
          BottomNavigationBarItem(
            label: "Criar",
            icon: Icon(
              Icons.add_circle_outline,
            ),
          ),
          BottomNavigationBarItem(
            label: "Mensagens",
            icon: Icon(
              Icons.cached,
            ),
          ),
          BottomNavigationBarItem(
            label: "Artigos",
            icon: Icon(
              Icons.article_outlined,
            ),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
