import 'dart:convert';
import 'package:aplikasi_manajemen_pariwisata/helpers/api.dart';
import 'package:aplikasi_manajemen_pariwisata/helpers/api_url.dart';
import 'package:aplikasi_manajemen_pariwisata/model/jadwal.dart';

class JadwalBloc {
  // Method untuk mendapatkan daftar jadwal keberangkatan dari API
  static Future<List<JadwalKeberangkatan>> getJadwals() async {
    String apiUrl = ApiUrl.listJadwal;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    // Ambil data jadwal dari hasil respons JSON
    List<dynamic> listJadwal = (jsonObj as Map<String, dynamic>)['data'];
    List<JadwalKeberangkatan> jadwals = [];

    // Loop untuk mengonversi data JSON ke dalam objek JadwalKeberangkatan
    for (var i = 0; i < listJadwal.length; i++) {
      jadwals.add(JadwalKeberangkatan.fromJson(listJadwal[i]));
    }

    return jadwals;
  }

  // Method untuk menambah jadwal keberangkatan baru melalui API
  static Future addJadwal({required JadwalKeberangkatan jadwal}) async {
    String apiUrl = ApiUrl.createJadwal;

    var body = {
      "transport": jadwal.transport,
      "route": jadwal.route,
      "frequency": jadwal.frequency.toString() // Ubah frequency ke string jika diperlukan oleh API
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    // Kembalikan status dari respons API
    return jsonObj['status'];
  }

  // Method untuk memperbarui data jadwal keberangkatan melalui API
  static Future updateJadwal({required JadwalKeberangkatan jadwal}) async {
    String apiUrl = ApiUrl.updateJadwal(jadwal.id!);

    var body = {
      "transport": jadwal.transport,
      "route": jadwal.route,
      "frequency": jadwal.frequency // Tetap integer jika format sesuai dengan API
    };

    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);

    // Kembalikan status dari respons API
    return jsonObj['status'];
  }

  // Method untuk menghapus jadwal berdasarkan ID melalui API
  static Future<bool> deleteJadwal({required int id}) async {
    String apiUrl = ApiUrl.deleteJadwal(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    // Kembalikan hasil penghapusan jadwal (berdasarkan data dari API)
    return (jsonObj as Map<String, dynamic>)['status'];
  }
}
