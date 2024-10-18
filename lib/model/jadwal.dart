class JadwalKeberangkatan {
  int? id;
  String? transport;
  String? route;
  int? frequency;

  JadwalKeberangkatan({this.id, this.transport, this.route, this.frequency});

  factory JadwalKeberangkatan.fromJson(Map<String, dynamic> obj) {
    return JadwalKeberangkatan(
      id: obj['id'],
      transport: obj['transport'],
      route: obj['route'],
      frequency: obj['frequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transport': transport,
      'route': route,
      'frequency': frequency,
    };
  }
}
