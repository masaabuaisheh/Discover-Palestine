import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'chatting_page.dart';

class NavbarSection extends StatefulWidget {
  const NavbarSection({super.key});

  @override
  State<NavbarSection> createState() => _NavbarSectionState();
}

class _NavbarSectionState extends State<NavbarSection> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const ChattingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          // Navigation Bar (positioned above the pages)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CurvedNavigationBar(
              backgroundColor:
                  Colors.transparent, // Make the background transparent
              buttonBackgroundColor: const Color(0xFFF5F0E5),
              color: Color(0xFFF5F0E5),
              items: const [
                Icon(Icons.chat, color: Color.fromARGB(255, 148, 148, 148)),
                Icon(Icons.home, color: Color.fromARGB(255, 148, 148, 148)),
                Icon(Icons.search, color: Color.fromARGB(255, 148, 148, 148)),
                Icon(Icons.event, color: Color.fromARGB(255, 148, 148, 148)),
                Icon(Icons.person, color: Color.fromARGB(255, 148, 148, 148)),
              ],
              height: 50,
              animationDuration: const Duration(milliseconds: 300),
              index: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
