import 'package:flutter/material.dart';
import '../checkout/checkout_screen.dart';
import '../checkout/checkout_screen.dart';
import 'cart_item.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> items;

  @override
  void initState() {
    super.initState();
    items = widget.cart.map((e) => CartItem.fromMap(e)).toList();
  }

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  void increaseQty(int index) {
    setState(() {
      items[index] = CartItem(
        name: items[index].name,
        price: items[index].price,
        qty: items[index].qty + 1,
        image: items[index].image,
      );
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (items[index].qty > 1) {
        items[index] = CartItem(
          name: items[index].name,
          price: items[index].price,
          qty: items[index].qty - 1,
          image: items[index].image,
        );
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),

      body: items.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.asset(item.image),
                    title: Text(item.name),
                    subtitle: Text("₦${item.price} x ${item.qty}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => decreaseQty(index),
                            ),
                            Text("${item.qty}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => increaseQty(index),
                            ),
                          ],
                        ),
                        Text(
                          "₦${item.subtotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Total: ₦${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutScreen(
                          cartItems:
                          items.map((e) => e.toMap()).toList(),
                          email: "user@email.com",
                        ),
                      ),
                    );
                  },
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}