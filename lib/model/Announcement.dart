class Announcement {
  final String id;
  final String surplusId;
  final String dealing;
  final bool negotiated;

  Announcement(
      {required this.id,
      required this.surplusId,
      required this.dealing,
      required this.negotiated});

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
        id: map['id'],
        surplusId: map['surplusId'],
        dealing: map['dealing'],
        negotiated: map['negotiated']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surplusId': surplusId,
      'dealing': dealing,
      'negotiated': negotiated,
    };
  }

}
