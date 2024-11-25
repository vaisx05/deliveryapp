import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderDetail extends StatelessWidget {
  final Order order;

  const OrderDetail({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer: ${order.customerName}",
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              )),
          const SizedBox(height: 8),
          Text("Total Amount: ₹${order.totalAmount}",
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              )),
          const SizedBox(height: 8),
          Text("Payment Status: ${order.paymentStatus}",
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              )),
          const SizedBox(height: 16),
          const Text("Pickup Details",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400)),
          ...order.pickupDetails.map((pickup) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pickup Point: ${pickup.pickupPoint}"),
                    Text("Address: ${pickup.address}"),
                    Text("Product: ${pickup.productName}"),
                    Text("Quantity: ${pickup.quantity}"),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
