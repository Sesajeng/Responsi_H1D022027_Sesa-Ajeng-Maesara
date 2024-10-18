import 'package:flutter/material.dart';
import '../bloc/jadwal_bloc.dart';
import '../widget/warning_dialog.dart';
import '/model/jadwal.dart';
import '/ui/jadwal_form.dart';
import 'jadwal_page.dart';

class CustomColors {
  static const Color pastelPink = Color(0xFFF1A7B4); // Warna pastel pink
  static const Color pastelYellow = Colors.white; // Warna pastel kuning
  static const Color whiteColor = Color(0xFFFFE29D);
}

class JadwalDetail extends StatefulWidget {
  final JadwalKeberangkatan? jadwal;

  const JadwalDetail({Key? key, this.jadwal}) : super(key: key);

  @override
  _JadwalDetailState createState() => _JadwalDetailState();
}

class _JadwalDetailState extends State<JadwalDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pastelYellow, // Warna background pastel kuning
      appBar: AppBar(
        title: const Text(
          'Detail Jadwal',
          style: TextStyle(color: CustomColors.whiteColor), // Warna teks putih
        ),
        backgroundColor: CustomColors.pastelPink, // Warna AppBar pastel pink
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailItem("ID", widget.jadwal!.id.toString()),
              _detailItem("Transport", widget.jadwal!.transport!),
              _detailItem("Route", widget.jadwal!.route!),
              _detailItem("Frequency", widget.jadwal!.frequency.toString()),
              const SizedBox(height: 30),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        "$label : $value",
        style: const TextStyle(fontSize: 18.0, color: Colors.black87),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Edit
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Tombol rounded
            ),
          ),
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JadwalForm(jadwal: widget.jadwal!),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        // Tombol Hapus
        ElevatedButton(
          style: ElevatedButton.styleFrom(

            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Tombol rounded
            ),
          ),
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: CustomColors.whiteColor,
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        // Tombol hapus
        TextButton(
          child: const Text("Ya", style: TextStyle(color: Colors.redAccent)),
          onPressed: () {
            JadwalBloc.deleteJadwal(id: widget.jadwal!.id!).then(
                  (value) {
                if (value) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const JadwalPage(),
                  ));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                      description: "Hapus gagal, silahkan coba lagi",
                    ),
                  );
                }
              },
            );
          },
        ),
        // Tombol batal
        TextButton(
          child: const Text("Batal", style: TextStyle(color: Colors.blueAccent)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
