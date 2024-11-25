import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/order_bloc.dart';
import 'bloc/order_event.dart';
import 'bloc/order_state.dart';
import 'widgets/order_detail.dart';
import 'widgets/order_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => OrderBloc()..add(FetchOrders()),
        child: const OrderScreen(),
      ),
    );
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Material(
          elevation: 8, // Adjust for shadow intensity
          shadowColor: Colors.black45, // Set shadow color
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            child: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(top: 28),
                child: Text(
                  'Orders',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true, // Remove AppBar's own elevation
            ),
          ),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return ExpansionTile(
                  title: Text(order.orderNumber),
                  subtitle: Text(order.status),
                  children: [
                    OrderDetail(order: order),
                    const SizedBox(height: 16),
                    OrderMap(pickupDetails: order.pickupDetails), // Add map here
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }
}