import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:get/get.dart';
import 'package:shardapooling/AdminPortal/home_admin.dart';
import 'package:shardapooling/AdminPortal/request_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;
  int _counter = 0;

  List listofBody = [
    const Scaffold(
      body: HomeAdmin(),
    ),
    Container(
      color: Colors.blue,
    ),
    const Scaffold(
      body: RequestPage(),
    ),
    Container(
      color: Colors.yellow,
      child: Center(
        child: MaterialButton(
          onPressed: () async {
            final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();

            sharedPreferences.remove("email");
            sharedPreferences.remove("page");
            Get.offAll(LoginPage());
          },
          child: const Text("Logout"),
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listofBody[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.transparent,
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.apps),
            title: const Text('Home'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.help_sharp),
            title: const Text('Help Center'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.support_agent_outlined),
            title: const Text(
              'Login Issue',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
