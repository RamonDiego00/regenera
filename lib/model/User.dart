// id
// nome de usuario
// foto
// email
// nome do jardim
// localização
// data de criação da conta
// dimensão da plantação em m2
// idade
// Quantidade de plantações do usuario

class User {
  final String id;
  final String name;
  final String email;
  final String garden;
  final String location;
  final String dimension;
  final String age;
  final String password;
  final String plantations;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.garden,
      required this.location,
      required this.dimension,
      required this.age,
      required this.plantations,
      required this.password});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      garden: map['garden'],
      location: map['location'],
      dimension: map['dimension'],
      age: map['age'],
      plantations: map['plantations'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'garden': garden,
      'location': location,
      'dimension': dimension,
      'age': age,
      'plantations': plantations,
    };
  }
}
