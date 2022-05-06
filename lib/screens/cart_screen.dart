import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Cart",
        ),
      ),
      body: Consumer<Cart>(
        builder: (context, value, child) => value.items.isEmpty
            ? const Center(
                child: Image(
                  image: AssetImage("lib/assets/images/noitems.png"),
                  fit: BoxFit.cover,
                ),
              )
            : Provider.of<OrderProvider>(context).isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(
                            15,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await Provider.of<OrderProvider>(
                                        context,
                                        listen: false,
                                      ).addOrder(
                                        value.items.values.toList(),
                                        value.totalAmount,
                                      );
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Row(
                                            children: const [
                                              Text("Order Sent Succefully"),
                                              Spacer(),
                                              Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                      value.clearCart();
                                    } catch (e) {
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: const [
                                              Text(
                                                  "Wrong in Sending the Order"),
                                              Spacer(),
                                              Icon(Icons.error_outline),
                                            ],
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "ORDER NOW",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Chip(
                                  elevation: 7,
                                  label: Text(
                                    "${value.totalAmount.toStringAsFixed(2)} \$",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  backgroundColor: Colors.purple,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          itemBuilder: ((context, index) {
                            return CartItemScreen(
                              productId: value.items.keys.toList()[index],
                              id: value.items.values.toList()[index].id,
                              price: value.items.values.toList()[index].price,
                              quantity:
                                  value.items.values.toList()[index].quantity,
                              title: value.items.values.toList()[index].title,
                            );
                          }),
                          itemCount: value.itemCount,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.scaffold,
    required this.value,
  }) : super(key: key);

  final ScaffoldMessengerState scaffold;
  final Cart value;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          await Provider.of<OrderProvider>(
            context,
            listen: false,
          ).addOrder(
            widget.value.items.values.toList(),
            widget.value.totalAmount,
          );
          widget.scaffold.showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Row(
                children: const [
                  Text("Order Sent Succefully"),
                  Spacer(),
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
          widget.value.clearCart();
        } catch (e) {
          widget.scaffold.showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Text("Wrong in Sending the Order"),
                  Spacer(),
                  Icon(Icons.error_outline),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: const Text(
        "ORDER NOW",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
