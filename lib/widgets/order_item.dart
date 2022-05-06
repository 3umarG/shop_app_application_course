import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order_provider.dart';

class OrderItem extends StatefulWidget {
  final OrderModel orderModel;

  const OrderItem({required this.orderModel});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "\$ ${widget.orderModel.amount}",
            ),
            subtitle: Text(
              DateFormat.yMMMd().format(widget.orderModel.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less_sharp : Icons.expand_more,
              ),
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              },
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(
                180,
                widget.orderModel.cartProducts.length * 20.0 + 100,
              ),
              child: ListView.builder(
                itemCount: widget.orderModel.cartProducts.length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orderModel.cartProducts[index].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${widget.orderModel.cartProducts[index].quantity} x ${widget.orderModel.cartProducts[index].price}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
