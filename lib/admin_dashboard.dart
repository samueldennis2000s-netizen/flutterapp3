import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Stream<QuerySnapshot> getOrders() {
    return FirebaseFirestore.instance.collectionGroup('orders').snapshots();
  }

  Stream<QuerySnapshot> getUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.black,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: getOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          double totalRevenue = 0;

          for (var doc in orders) {
            final data = doc.data() as Map<String, dynamic>;
            totalRevenue += (data['total'] ?? 0);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📊 Overview",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _buildCard("Total Orders", orders.length.toString()),
                _buildCard("Total Revenue", "₦$totalRevenue"),

                const SizedBox(height: 30),

                const Text(
                  "🧾 Recent Orders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length > 10 ? 10 : orders.length,
                  itemBuilder: (context, index) {
                    final data =
                    orders[index].data() as Map<String, dynamic>;

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt),
                        title: Text("Order ${orders[index].id}"),
                        subtitle: Text(
                          "₦${data['total']} • ${data['itemCount']} items",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}