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

class DropDetails {
  final String address;
  final String productName;
  final int quantity;
  final double latitude;
  final double longitude;

  DropDetails({
    required this.address,
    required this.productName,
    required this.quantity,
    required this.latitude,
    required this.longitude,
  });
}

class Order {
  final String orderNumber;
  final String status;
  final String customerName;
  final List<PickupDetail> pickupDetails;
  final List<DropDetails> dropDetails;
  final double totalAmount;
  final String paymentStatus;

  Order({
    required this.orderNumber,
    required this.status,
    required this.customerName,
    required this.pickupDetails,
    required this.dropDetails,
    required this.totalAmount,
    required this.paymentStatus,
  });
}
