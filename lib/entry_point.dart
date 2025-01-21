import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/screens/home/QAN.dart';
import 'package:foodly_ui/screens/home/ZakatCalculator.dart';

import 'constants.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  // Bydefault first one is selected
  int _selectedIndex = 0;

  // List of nav items
  final List<Map<String, dynamic>> _navitems = [
    {"icon": "assets/icons/home.svg", "title": "Home"},
    {"icon": "assets/icons/order.svg", "title": "Zakat"},
    {"icon": "assets/icons/order.svg", "title": "Q&A"},
    {"icon": "assets/icons/profile.svg", "title": "Profil"},
  ];

// Screens
  final List<Widget> _screens = [
    const HomeScreen(),
    // const SearchScreen(),
    AddAssetZaketPage(),
    FAQScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    /// If you set your home screen as first screen make sure call [SizeConfig().init(context)]

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CupertinoTabBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        activeColor: thirdColor,
        inactiveColor: Colors.grey.shade500,
        items: List.generate(
          _navitems.length,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _navitems[index]["icon"],
              height: 30,
              width: 30,
              colorFilter: ColorFilter.mode(
                  index == _selectedIndex ? thirdColor : Colors.grey.shade500,
                  BlendMode.srcIn),
            ),
            label: _navitems[index]["title"],
          ),
        ),
      ),
    );
  }
}
