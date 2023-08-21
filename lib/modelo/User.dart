class User {
  int? id;
  String? email;
  bool? isAdmin;


  User({this.id, this.email, this.isAdmin});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      email: json['user']['email'],   
    );
  }
}
