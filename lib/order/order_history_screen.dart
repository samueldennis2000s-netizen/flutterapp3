import 'package:flutter/material.dart';
import '../order_details_screen.dart';
import 'order_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String searchQuery = "";

  String formatDate(dynamic timestamp) {
    if (timestamp == null) return "Unknown date";

    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  String formatMoney(num value) {
    return "₦${value.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [
          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: "Search order ID...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 📦 STREAM BUILDER (REAL-TIME FIRESTORE)
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: OrderService.getOrders(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var orders = snapshot.data!;

                // 🔎 FILTER SEARCH
                if (searchQuery.isNotEmpty) {
                  orders = orders.where((order) {
                    final id = order['id'].toString().toLowerCase();
                    return id.contains(searchQuery);
                  }).toList();
                }

                if (orders.isEmpty) {
                  return const Center(
                    child: Text("No orders found"),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    final id = order['id'];
                    final itemCount = order['itemCount'] ?? 0;
                    final date = order['createdAt'];
                    final total = order['total'] ?? 0;

                    return Dismissible(
                      key: Key(id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        OrderService.deleteOrder(id);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete,
                            color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.receipt,
                              color: Colors.green),
                          title: Text("Order $id"),
                          subtitle: Text(
                            "$itemCount items • ${formatDate(date)}",
                          ),
                          trailing: Text(
                            formatMoney(total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    OrderDetailScreen(order: order),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}