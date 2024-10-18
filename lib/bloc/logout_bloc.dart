import 'package:aplikasi_manajemen_pariwisata/helpers/user_info.dart';

class LogoutBloc {
  static Future logout() async {
    await UserInfo().logout();
  }
}
