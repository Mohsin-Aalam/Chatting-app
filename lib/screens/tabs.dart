import 'package:flutter/material.dart';
import 'package:message_app/screens/user_screen.dart';
import 'package:message_app/screens/profile.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    print(_selectedPageIndex);
  }

  List<Widget> widgetList = const [
    UserListScreen(),
    ProfileScreen(),
  ];

  final PageController _pageController = PageController();
  void _onItemTapped(int i) {
    _pageController.jumpToPage(i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _selectPage,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        iconSize: 30,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'chat',
            activeIcon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_3_outlined),
              label: 'profile',
              activeIcon: Icon(Icons.person_3_rounded))
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedPageIndex,
      ),
    );
  }
}
