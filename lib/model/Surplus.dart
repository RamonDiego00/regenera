class Surplus {
  final String id;
  final String userId;
  final String name;
  final String photos;
  final String category;
  final String units;
  final String date;

  Surplus(
      {required this.id,
      required this.userId,
      required this.name,
      required this.photos,
      required this.category,
      required this.units,
      required this.date});

// id
// userid
// nome do execedente
// fotos
// Categoria do exedente()
// Unidades (kg , uni, hrs)
// data de criação do exedente
// avaliação da fazenda

  factory Surplus.fromMap(Map<String, dynamic> map) {
    return Surplus(
        id: map['id'],
        name: map['name'],
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
      "userId": userId,
      "category": category,
      "date": date,
      "photos": photos,
      "units": units
    };
  }
}
