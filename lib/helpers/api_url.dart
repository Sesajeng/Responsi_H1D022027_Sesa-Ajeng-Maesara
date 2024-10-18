class ApiUrl {
  static const String baseUrl = 'http://103.196.155.42/api';

  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';
  static const String listJadwal = '$baseUrl/pariwisata/jadwal_keberangkatan';
  static const String createJadwal = '$baseUrl/pariwisata/jadwal_keberangkatan';

  static String updateJadwal(int id) {
    return '$baseUrl/pariwisata/jadwal_keberangkatan/$id/update';
  }

  static String showJadwal(int id) {
    return '$baseUrl/pariwisata/jadwal_keberangkatan/$id';
  }

  static String deleteJadwal(int id) {
    return '$baseUrl/pariwisata/jadwal_keberangkatan/$id/delete';
  }
}
