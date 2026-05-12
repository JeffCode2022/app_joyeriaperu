/// Customization option for a product (size, material, color, etc.)
class ProductOption {
  final String label;
  final List<String> values;
  final Map<String, double>? priceModifiers; // value -> price delta

  const ProductOption({
    required this.label,
    required this.values,
    this.priceModifiers,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
        label: json['label'] as String,
        values: List<String>.from(json['values'] as List),
        priceModifiers: json['priceModifiers'] != null
            ? Map<String, double>.from(
                (json['priceModifiers'] as Map).map(
                  (k, v) => MapEntry(k as String, (v as num).toDouble()),
                ),
              )
            : null,
      );
}

/// Product entity — core business object.
class Product {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final double price;
  final double? promoPrice;
  final List<String> images;
  final List<ProductOption> options;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFeatured;
  final String material;
  final String? karats;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    this.promoPrice,
    required this.images,
    this.options = const [],
    this.tags = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.isNew = false,
    this.isFeatured = false,
    this.material = 'Oro',
    this.karats,
  });

  bool get hasPromo => promoPrice != null && promoPrice! < price;

  double get discountPercent {
    if (!hasPromo) return 0;
    return ((price - promoPrice!) / price * 100).roundToDouble();
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        categoryId: json['categoryId'] as String,
        price: (json['price'] as num).toDouble(),
        promoPrice: json['promoPrice'] != null
            ? (json['promoPrice'] as num).toDouble()
            : null,
        images: List<String>.from(json['images'] as List),
        options: (json['options'] as List?)
                ?.map((e) =>
                    ProductOption.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        tags: List<String>.from(json['tags'] as List? ?? []),
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: json['reviewCount'] as int? ?? 0,
        isNew: json['isNew'] as bool? ?? false,
        isFeatured: json['isFeatured'] as bool? ?? false,
        material: json['material'] as String? ?? 'Oro',
        karats: json['karats'] as String?,
      );
}
