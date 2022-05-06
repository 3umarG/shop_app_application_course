import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItemScreen extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  const CartItemScreen({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).deleteFromCart(productId);
      },
      confirmDismiss: (DismissDirection direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are You Sure ??"),
            content: const Text("Do you want to Remove item from Cart ???"),
            actions: [
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        );
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          icon: const Icon(Icons.remove_shopping_cart_outlined),
          onPressed: () {},
          iconSize: 40,
          color: Colors.white,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Card(
        elevation: 7,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 6,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    "$price \$",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Colors.purple,
              ),
            ),
            subtitle: Text(
              "Total : ${(price * quantity).toStringAsFixed(2)} \$",
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            trailing: Text(
              "$quantity x",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
