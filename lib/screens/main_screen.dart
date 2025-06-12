import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_sarpras_mobile/components/bottom_navbar.dart';
import 'package:sisfo_sarpras_mobile/screens/landing_screen.dart';
import 'package:sisfo_sarpras_mobile/screens/peminjaman_screen.dart';
import 'package:sisfo_sarpras_mobile/screens/pengembalian_scree.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int? idUser;

  @override
  void initState() {
    super.initState();
    getIdUserLogin();
  }

  Future<void> getIdUserLogin() async{
    final prefs = await SharedPreferences.getInstance();
    final id = await prefs.getInt('id');
    setState(() {
      idUser = id;
    });
  }

  final List<BottomNavBarItem> navItems = [
    BottomNavBarItem(icon: Icons.home, label: 'Beranda'),
    BottomNavBarItem(icon: Icons.inventory, label: 'Peminjaman'),
    BottomNavBarItem(icon: Icons.history, label: 'Pengembalian'),
  ];

  Widget build(BuildContext context) {

    final List<Widget> _pages = [
    LandingScreen(),
    PeminjamanScreen(id: idUser!,),
    PengembalianScree(id: idUser!,),
  ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: navItems,
      ),
    );
  }
}