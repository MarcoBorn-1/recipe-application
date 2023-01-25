class IngredientPreview {
  IngredientPreview(
      {required this.id,
      required this.name,
      required this.image,});
  final int id;
  final String name;
  final String image;

  factory IngredientPreview.fromJson(Map<String, dynamic> json) {
    return IngredientPreview(
        id: json['id'],
        name: json['name'],
        image: json['image']
    );
  }
}
