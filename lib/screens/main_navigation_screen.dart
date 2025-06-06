import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'tracking_screen.dart';
import 'register_badge/register_badge_screen.dart';
import 'profile/profile_screen.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TrackingScreen(),
    const RegisterBadgeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2632),
        ),
        child: BottomBarFloating(
            indexSelected: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: const Color(0xFF1E2632),
            colorSelected: Colors.white,
            color: Color(0xFFA0AEC0),
            items: const [
              TabItem(
                icon: Icons.map,
                title: 'Tracking',
              ),
              TabItem(
                icon: Icons.home_repair_service,
                title: 'Register badge',
              ),
              TabItem(
                icon:  Icons.person,
                title: 'Profile',
              ),
            ],
          ),
      ),
    );
  }
} 