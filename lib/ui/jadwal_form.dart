import 'package:flutter/material.dart';
import '../bloc/jadwal_bloc.dart';
import '../widget/warning_dialog.dart';
import '../model/jadwal.dart';
import 'jadwal_page.dart';

class CustomColors {
  static const Color pastelPink = Color(0xFFF1A7B4); // Warna pastel pink
  static const Color pastelYellow = Color(0xFFFFFBF0); // Warna pastel kuning
  static const Color pastelGreen = Color(0xFFC1E1C1); // Warna pastel hijau
  static const Color whiteColor = Colors.white;
  static const Color blackText = Colors.black87;
}

class JadwalForm extends StatefulWidget {
  JadwalKeberangkatan? jadwal;

  JadwalForm({Key? key, this.jadwal}) : super(key: key);

  @override
  _JadwalFormState createState() => _JadwalFormState();
}

class _JadwalFormState extends State<JadwalForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH JADWAL";
  String tombolSubmit = "SIMPAN";
  final _transportTextboxController = TextEditingController();
  final _routeTextboxController = TextEditingController();
  final _frequencyTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  @override
  void dispose() {
    _transportTextboxController.dispose();
    _routeTextboxController.dispose();
    _frequencyTextboxController.dispose();
    super.dispose();
  }

  isUpdate() {
    if (widget.jadwal != null) {
      setState(() {
        judul = "UBAH JADWAL";
        tombolSubmit = "UBAH";
        _transportTextboxController.text = widget.jadwal!.transport!;
        _routeTextboxController.text = widget.jadwal!.route!;
        _frequencyTextboxController.text = widget.jadwal!.frequency.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pastelYellow, // Warna background pastel kuning
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(color: CustomColors.whiteColor), // Teks putih
        ),
        backgroundColor: CustomColors.pastelPink, // Warna AppBar pastel pink
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inputTextField("Transportasi", _transportTextboxController),
              _inputTextField("Rute", _routeTextboxController),
              _inputTextField("Frekuensi (per hari)", _frequencyTextboxController, isNumber: true),
              const SizedBox(height: 20),
              _buttonSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: CustomColors.blackText),
          filled: true,
          fillColor: CustomColors.whiteColor, // Background field putih
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "$label harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonSubmit() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Tombol rounded
          ),
        ),
        child: Text(tombolSubmit),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.jadwal != null) {
                ubah(); // Kondisi update jadwal
              } else {
                simpan(); // Kondisi tambah jadwal
              }
            }
          }
        },
      ),
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });
    JadwalKeberangkatan createJadwal = JadwalKeberangkatan(id: null);
    createJadwal.transport = _transportTextboxController.text;
    createJadwal.route = _routeTextboxController.text;
    createJadwal.frequency = int.parse(_frequencyTextboxController.text);

    JadwalBloc.addJadwal(jadwal: createJadwal).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const JadwalPage()),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });
    JadwalKeberangkatan updateJadwal = JadwalKeberangkatan(id: widget.jadwal!.id!);
    updateJadwal.transport = _transportTextboxController.text;
    updateJadwal.route = _routeTextboxController.text;
    updateJadwal.frequency = int.parse(_frequencyTextboxController.text);

    JadwalBloc.updateJadwal(jadwal: updateJadwal).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const JadwalPage()),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
