import 'package:elite_admin_panel/Screen/OrderPage.dart';
import 'package:elite_admin_panel/Screen/allUser.dart';
import 'package:elite_admin_panel/Screen/home_screen.dart';
import 'package:elite_admin_panel/Screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List Pages = [
    Home_page_admin(),
    allUser(),
    OrderPage(),
    PtrofileScreen(),
  ];
  
  int currentIndex = 0;
  void onTabChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[currentIndex],
      bottomNavigationBar: _customeBottomNavigationBar(),
    );
  }

  _customeBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GNav(
            // backgroundColor: Colors.transparent,
            // color: Colors.grey,
            gap: 8,
            tabBackgroundColor: Color(0xFF133762),
            padding: const EdgeInsets.all(10),
            onTabChange: onTabChange,
            tabs: [
              GButton(
                icon: currentIndex == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house,
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: currentIndex == 1 ? CupertinoIcons.person_2_fill : CupertinoIcons.person_2,
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: currentIndex == 2 ? CupertinoIcons.bag_fill : CupertinoIcons.bag,
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: currentIndex == 3 ? CupertinoIcons.person_solid : CupertinoIcons.person,
                iconActiveColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}