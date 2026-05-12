/// Represents an item in the shopping cart with selected customization options.
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;
  final Map<String, String> selectedOptions; // label -> selected value

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    this.quantity = 1,
    this.selectedOptions = const {},
  });

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    int? quantity,
    Map<String, String>? selectedOptions,
  }) =>
      CartItem(
        id: id,
        productId: productId,
        productName: productName,
        productImage: productImage,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        selectedOptions: selectedOptions ?? this.selectedOptions,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'productName': productName,
        'productImage': productImage,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'selectedOptions': selectedOptions,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String,
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        productImage: json['productImage'] as String,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        quantity: json['quantity'] as int? ?? 1,
        selectedOptions: Map<String, String>.from(
            json['selectedOptions'] as Map? ?? {}),
      );
}
