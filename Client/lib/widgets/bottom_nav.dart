import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:life_os/views/ai_view.dart';
import 'package:life_os/views/notes_view.dart';
import 'package:life_os/views/profile_view.dart';
import 'package:life_os/views/tasks_view.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
  
    TasksView(),
    Notes_view(),
    AIview(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: const Color(0xFF0FA4A5),

          gap: 8,
          padding: const EdgeInsets.all(16),
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.task, text: 'Tasks'),
            GButton(icon: Icons.notes, text: 'Notes'),
            GButton(icon: Icons.adb, text: 'AI assistant'),
            GButton(icon: Icons.face_6_sharp, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
