/// Represents a product category in the jewelry store.
class Category {
  final String id;
  final String name;
  final String icon;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.productCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        productCount: json['productCount'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'productCount': productCount,
      };
}
