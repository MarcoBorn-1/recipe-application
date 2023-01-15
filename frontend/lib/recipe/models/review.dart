class Review {
  Review(
      {required this.rating,
      required this.userUID,
      required this.username,
      required this.comment,
      required this.userImageURL});
  final int rating;
  final String userUID;
  final String username;
  final String comment;
  final String userImageURL;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        rating: json['rating'],
        userUID: json['userUID'],
        username: json['username'],
        comment: json['comment'],
        userImageURL: json['userImageURL']);
  }
}
