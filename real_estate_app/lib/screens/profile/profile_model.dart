class Profile {
  String name;
  String email;
  String phone;
  String gender;
  String age;
  String role;
  String? image;

  Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.role,
    this.image,
  });

  static Profile fromJson(Map<String, dynamic> json) => Profile(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        gender: json['gender'],
        age: json['age'],
        role: json['role'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'age': age,
        'role': role,
      };
}
