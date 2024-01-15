import 'dart:convert';

class Booking {
  int id;
  String user_id;
  String ruangan_id;
  String created_at;
  String updated_at;
  DateTime start_book;
  DateTime end_book;

  Booking({
    this.id = 0,
    required this.user_id,
    required this.ruangan_id,
    required this.start_book,
    required this.end_book,
    required this.created_at,
    required this.updated_at,
  });

  factory Booking.fromJson(Map<String, dynamic> map) {
    return Booking(
      id: map["id"],
      user_id: map["user_id"],
      ruangan_id: map["ruangan_id"],
      start_book: DateTime.parse(map["start_book"]),
      end_book: DateTime.parse(map["end_book"]),
      created_at: map["created_at"],
      updated_at: map["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": user_id,
      "ruangan_id": ruangan_id,
      "start_book": start_book.toUtc().toIso8601String(),
      "end_book": end_book.toUtc().toIso8601String(),
      "created_at": created_at,
      "updated_at": updated_at,
    };
  }

  @override
  String toString() {
    return 'Booking{id: $id, user_id: $user_id, ruangan_id: $ruangan_id, created_at: $created_at, "updated_at": $updated_at }';
  }
}

List<Booking> bookingFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Booking>.from(data.map((item) => Booking.fromJson(item)));
}

String bookingToJson(Booking data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
