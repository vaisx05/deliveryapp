class Order {
  final String orderNumber;
  final String status;
  final String customerName;
  final List<PickupDetail> pickupDetails;
  final double totalAmount;
  final String paymentStatus;

  Order({
    required this.orderNumber,
    required this.status,
    required this.customerName,
    required this.pickupDetails,
    required this.totalAmount,
    required this.paymentStatus,
  });
}

class PickupDetail {
  final String pickupPoint;
  final String address;
  final String productName;
  final int quantity;
  final double latitude;
  final double longitude;

  PickupDetail({
    required this.pickupPoint,
    required this.address,
    required this.productName,
    required this.quantity,
    required this.latitude,
    required this.longitude,
  });
}
