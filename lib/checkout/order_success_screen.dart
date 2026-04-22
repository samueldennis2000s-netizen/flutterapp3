import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class OrderSuccessScreen extends StatefulWidget {
  final double totalAmount;
  final String orderId;

  const OrderSuccessScreen({
    super.key,
    required this.totalAmount,
    required this.orderId,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakSuccess();
  }

  Future<void> _speakSuccess() async {
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.5);
    await tts.setVolume(0.6);

    await tts.speak(
        "Order ${widget.orderId} placed successfully. "

    );
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: const Text("Order Receipt"),
      ),

      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle,
                    color: Colors.green, size: 80),

                const SizedBox(height: 10),

                const Text(
                  "Order Successful",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const Divider(height: 30),

                //RECEIPT DETAILS
                _row("Order ID", widget.orderId),
                _row("Payment", "Completed"),
                _row("Order Status", "Processing Delivery,"),


                const Divider(),

                _row(
                  "Total",
                  "\$${widget.totalAmount.toStringAsFixed(2)}",
                  bold: true,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    "Back to Home Screen",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
