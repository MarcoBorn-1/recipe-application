class UserInformation {
  final String username;
  final String imageURL;

  UserInformation({required this.username, required this.imageURL});

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
        username: json['username'], imageURL: json['imageURL']);
  }
}
