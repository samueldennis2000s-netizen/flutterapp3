import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});

  String formatDate(String? date) {
    if (date == null) return "Unknown";
    try {
      final d = DateTime.parse(date);
      return "${d.day}/${d.month}/${d.year}";
    } catch (_) {
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = order['id'] ?? 'Unknown';
    final items = order['items'] ?? [];
    final total = order['total'] ?? 0;
    final date = order['date'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Order $id"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${formatDate(date)}"),
            const SizedBox(height: 10),
            Text("Total: ₦$total",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 30),
            const Text("Items:",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(item['name'] ?? 'Item'),
                    subtitle:
                    Text("Qty: ${item['qty'] ?? 1}"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}