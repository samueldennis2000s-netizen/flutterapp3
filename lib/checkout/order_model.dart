class OrderModel {
  final String id;
  final double total;
  final DateTime date;
  final int itemCount;
  final String status;
  final List<Map<String, dynamic>> items;

  OrderModel({
    required this.id,
    required this.total,
    required this.date,
    required this.itemCount,
    this.status = "Pending",
    required this.items,
  });
}