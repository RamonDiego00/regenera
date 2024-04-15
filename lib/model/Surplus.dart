class Surplus {
  final String id;
  final String userId;
  final String name;
  final String location;
  final String description;
  final List<String> photos;
  final String category;
  final String units;
  final String date;

  Surplus(
      {required this.id,
      required this.userId,
      required this.name,
      required this.location,
      required this.description,
      required this.photos,
      required this.category,
      required this.units,
      required this.date});

  factory Surplus.fromMap(Map<String, dynamic> map) {
    return Surplus(
        id: map['id'],
        name: map['name'],
        location: map['location'],
        description: map['description'],
        userId: map['userId'],
        category: map['category'],
        date: map['date'],
        photos: map['photos'],
        units: map['units']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "location": location,
      "description": description,
      "userId": userId,
      "category": category,
      "date": date,
      "photos": photos,
      "units": units
    };
  }
}
