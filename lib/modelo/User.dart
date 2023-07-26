class User {
  int? id;
  String? name;
  String? email;
  String? telefoneFixo;
  String? telefoneCelular;

  User({this.id, this.name, this.email, this.telefoneFixo, this.telefoneCelular});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      telefoneFixo: json['user']['telefoneFixo'],
      telefoneCelular: json['user']['telefoneCelular'],
    );
  }
}
