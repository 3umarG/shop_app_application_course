import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;
  Future returnFutureGetOrders() {
    return Provider.of<OrderProvider>(context, listen: false).getTheOrders();
  }

  @override
  void initState() {
    _ordersFuture = returnFutureGetOrders();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Orders",
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(
              child: Text("An Error Occured ...!"),
            );
          } else {
            return Consumer<OrderProvider>(
              builder: (BuildContext context, OrderProvider orderProvider,
                  Widget? child) {
                return ListView.builder(
                  itemBuilder: ((context, index) =>
                      OrderItem(orderModel: orderProvider.orders[index])),
                  itemCount: orderProvider.orders.length,
                );
              },
            );
          }
        },
      ),
    );
  }
}
