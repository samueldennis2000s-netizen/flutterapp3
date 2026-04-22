import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String email;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.email,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  double get totalAmount {
    return widget.cartItems.fold(
      0,
          (sum, item) => sum + (item["price"] * item["qty"]),
    );
  }

  Future<void> makePayment() async {
    final txRef = "SG-${Random().nextInt(999999999)}";

    final flutterwave = Flutterwave(
      publicKey: "YOUR_FLUTTERWAVE_PUBLIC_KEY",
      currency: "NGN",
      redirectUrl: "https://google.com",
      txRef: txRef,
      amount: totalAmount.toString(),
      customer: Customer(
        name: "Smart Grocery User",
        phoneNumber: "08000000000",
        email: widget.email,
      ),
      paymentOptions: "card, banktransfer, ussd",
      customization: Customization(
        title: "Smart Grocery Checkout",
        description: "Payment for grocery items",
        logo: "",
      ),
      isTestMode: true,
    );

    final response = await flutterwave.charge(context);

    if (response.status == "successful") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Successful 🎉")),
      );

      // TODO: save order to Firebase or Node.js backend
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Failed ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [

          // 🛒 CART LIST
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];

                return ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(item["name"]),
                  subtitle: Text("Qty: ${item["qty"]}"),
                  trailing: Text("₦${item["price"] * item["qty"]}"),
                );
              },
            ),
          ),

          // 💰 TOTAL SECTION
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₦$totalAmount",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: makePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}