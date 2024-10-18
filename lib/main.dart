import 'package:flutter/material.dart';
import 'package:aplikasi_manajemen_pariwisata/helpers/user_info.dart';
import 'package:aplikasi_manajemen_pariwisata/ui/login_page.dart';
import 'package:aplikasi_manajemen_pariwisata/ui/jadwal_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    // Check if the user is logged in by retrieving the token
    var token = await UserInfo().getToken();

    // Update the page based on the token availability
    if (token != null) {
      setState(() {
        page = const JadwalPage(); // Navigate to the JadwalPage if logged in
      });
    } else {
      setState(() {
        page = const LoginPage(); // Navigate to the LoginPage if not logged in
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Manajemen Pariwisata',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: page), // Center the loading indicator or page
      ),
    );
  }
}
