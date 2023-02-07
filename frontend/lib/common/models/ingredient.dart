class Ingredient {
  Ingredient({required this.id, required this.name, required this.amount, required this.unit});
  final int id;
  final String name;
  final double amount;
  final String unit;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      unit: json['unit']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'unit': unit,
  };
}
