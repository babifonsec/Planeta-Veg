class User {
  int? id;
  String? email;


  User({this.id, this.email});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      email: json['user']['email'],   
    );
  }
}
