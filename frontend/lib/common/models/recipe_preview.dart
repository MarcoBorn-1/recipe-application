class RecipePreview {
  RecipePreview(
      {required this.id,
      required this.title,
      required this.imageURL,
      required this.readyInMinutes,
      required this.calories, 
      required this.isExternal});
  final int id;
  final String title;
  final String imageURL;
  final double readyInMinutes;
  final double calories;
  final bool isExternal;

  factory RecipePreview.fromJson(Map<String, dynamic> json) {
    return RecipePreview(
        id: json['id'],
        title: json['title'],
        imageURL: json['imageURL'],
        readyInMinutes: json['readyInMinutes'],
        calories: json['calories'],
        isExternal: json['external']);
  }
}
