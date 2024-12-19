class UserModel {
  final String name;
  final String email;
  final String uId;
  final String phone;
  final String nation;
  final String image;
  final String token;

  UserModel({
    required this.token,
    required this.phone,
    required this.image,
    required this.nation,
    required this.name,
    required this.email,
    required this.uId,
  });
}

// enum Nation 
//   InSaudi,
//   OutSaudi,
// }
