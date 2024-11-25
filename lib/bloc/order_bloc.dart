import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/order_model.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrdersLoading()) {
    on<FetchOrders>(_fetchOrders);
  }

  Future<void> _fetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    final orders = [
      Order(
        orderNumber: "#11250",
        status: "Pickup Pending",
        customerName: "Aman Sharma",
        pickupDetails: [
          PickupDetail(
            pickupPoint: "Pickup Center-1",
            address: "Nikitha Stores, 201/8, Nirant Apts, Andheri East 400069",
            productName: "Besan Ladoo",
            quantity: 2,
            latitude: 19.107567,
            longitude: 72.837750,
          ),
          PickupDetail(
            pickupPoint: "Pickup Center-2",
            address: "Ananta Stores, 204/C, Apts, Andheri East 400069",
            productName: "Atta Ladoo",
            quantity: 3,
            latitude: 19.111123,
            longitude: 72.835580,
          ),
        ],
        totalAmount: 2300.0,
        paymentStatus: "Paid",
      ),
      Order(
        orderNumber: "#11250",
        status: "Pickup Pending",
        customerName: "Aman Sharma",
        pickupDetails: [
          PickupDetail(
            pickupPoint: "Pickup Center-1",
            address: "Nikitha Stores, 201/8, Nirant Apts, Andheri East 400069",
            productName: "Besan Ladoo",
            quantity: 2,
            latitude: 19.107567,
            longitude: 72.837750,
          ),
          PickupDetail(
            pickupPoint: "Pickup Center-2",
            address: "Ananta Stores, 204/C, Apts, Andheri East 400069",
            productName: "Atta Ladoo",
            quantity: 3,
            latitude: 19.111123,
            longitude: 72.835580,
          ),
        ],
        totalAmount: 2300.0,
        paymentStatus: "Paid",
      ),
    ];

    emit(OrdersLoaded(orders));
  }
}
