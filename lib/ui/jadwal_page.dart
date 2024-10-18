import 'package:flutter/material.dart';
import 'package:aplikasi_manajemen_pariwisata/bloc/logout_bloc.dart';
import 'package:aplikasi_manajemen_pariwisata/bloc/jadwal_bloc.dart';
import 'package:aplikasi_manajemen_pariwisata/model/jadwal.dart';
import 'package:aplikasi_manajemen_pariwisata/ui/jadwal_detail.dart';
import 'package:aplikasi_manajemen_pariwisata/ui/jadwal_form.dart';
import 'login_page.dart';

class CustomColors {
  static const Color pastelPink = Color(0xFFF1A7B4);
  static const Color pastelYellow = Color(0xFFFFFBF0); // Warna pastel kuning yang sangat kalem
  static const Color whiteColor = Colors.white;
}

class JadwalPage extends StatefulWidget {
  const JadwalPage({Key? key}) : super(key: key);

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pastelYellow, // Background warna pastel kuning
      appBar: AppBar(
        title: const Text(
          'List Jadwal Keberangkatan',
          style: TextStyle(color: CustomColors.whiteColor), // Warna putih pada title
        ),
        backgroundColor: CustomColors.pastelPink, // Menggunakan warna pastel pink untuk AppBar
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: const Icon(Icons.add, size: 26.0, color: CustomColors.whiteColor), // Warna putih untuk icon tambah
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => JadwalForm()));
                },
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false)
                });
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: JadwalBloc.getJadwals(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListJadwal(list: snapshot.data)
              : const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ListJadwal extends StatelessWidget {
  final List? list;

  const ListJadwal({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemJadwal(
          jadwal: list![i],
        );
      },
    );
  }
}

class ItemJadwal extends StatelessWidget {
  final JadwalKeberangkatan jadwal;

  const ItemJadwal({Key? key, required this.jadwal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: CustomColors.whiteColor, // Background putih untuk kartu
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          title: Text(
            jadwal.transport!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Warna teks lebih gelap
            ),
          ),
          subtitle: Text(
            'Route: ${jadwal.route!}, Frequency: ${jadwal.frequency}',
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: Text(
            jadwal.id.toString(),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JadwalDetail(jadwal: jadwal)));
      },
    );
  }
}
