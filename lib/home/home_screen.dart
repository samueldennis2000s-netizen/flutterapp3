import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../cart/cart_page.dart';
import '../../cart/cart_item.dart';
import 'package:flutterapp3/notification/notification_page.dart';
import 'package:flutterapp3/notification/notification_model.dart';
import '../../profile/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final user = FirebaseAuth.instance.currentUser;

  String get userName => user?.displayName ?? "User";
  String get userEmail => user?.email ?? "No Email";

  final String userCity = "Your City";

  final List<Map<String, dynamic>> products = [
    {"name": "Apples", "price": 5.0, "image": "assets/image/apples.png"},
    {"name": "Bread", "price": 2.5, "image": "assets/image/bread.png"},
    {"name": "Milk", "price": 1.8, "image": "assets/image/milk.png"},
    {"name": "Tomatoes", "price": 3.0, "image": "assets/image/tomatoes.png"},
    {"name": "Eggs", "price": 2.0, "image": "assets/image/eggs.png"},
    {"name": "Biscuits", "price": 2.5, "image": "assets/image/biscuits.png"},
  ];

  List<CartItem> cart = [];
  List<AppNotification> notifications = [];

  void addToCart(Map<String, dynamic> product) {
    int index = cart.indexWhere((item) => item.name == product['name']);

    setState(() {
      if (index != -1) {
        cart[index] = CartItem(
          name: cart[index].name,
          price: cart[index].price,
          qty: cart[index].qty + 1,
          image: cart[index].image,
        );
      } else {
        cart.add(
          CartItem(
            name: product['name'],
            price: (product['price'] as num).toDouble(),
            qty: 1,
            image: product['image'],
          ),
        );
      }

      notifications.add(
        AppNotification(
          title: "Added to Cart",
          body: "${product["name"]} added successfully",
          time: DateTime.now(),
        ),
      );
    });

    Fluttertoast.showToast(msg: "${product["name"]} added");
  }

  int get totalCartQty =>
      cart.fold(0, (sum, item) => sum + item.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],

      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery to",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            Text(userCity,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NotificationPage(notifications: notifications),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    name: userName,
                    email: userEmail,
                    city: userCity,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            child: Column(
              children: [
                Image.asset(product["image"],
                    height: 110, fit: BoxFit.cover),
                Text(product["name"]),
                Text("₦${product["price"]}"),
                ElevatedButton(
                  onPressed: () => addToCart(product),
                  child: const Text("Add to cart"),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(
                    cart: cart.map((e) => e.toMap()).toList(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.shopping_basket),
          ),

          if (cart.isNotEmpty)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text("$totalCartQty"),
              ),
            ),
        ],
      ),
    );
  }
}