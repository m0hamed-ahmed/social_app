class UserModel {
  String userId;
  String name;
  String email;
  String password;
  String phone;
  String bio;
  String image;
  String cover;
  bool isEmailVerified;

  UserModel({this.userId, this.name, this.email, this.password, this.phone, this.bio, this.image, this.cover, this.isEmailVerified});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['uid'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    bio = json['bio'];
    image = json['image'];
    cover = json['cover'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': userId,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'bio': bio,
      'image': image,
      'cover': cover,
      'isEmailVerified': isEmailVerified,
    };
  }
}