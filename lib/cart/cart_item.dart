class CartItem {
  final String name;
  final double price;
  final int qty;
  final String image;

  CartItem({
    required this.name,
    required this.price,
    required this.qty,
    required this.image,
  });

  double get subtotal => price * qty;

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      qty: map['qty'] ?? 1,
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'qty': qty,
      'image': image,
    };
  }
}