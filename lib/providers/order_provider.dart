import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItem> cartProducts;
  final DateTime dateTime;

  OrderModel({
    required this.id,
    required this.amount,
    required this.cartProducts,
    required this.dateTime,
  });
}

class OrderProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List<OrderModel> _orders = [];

  OrderProvider(
    this.authToken,
    this._orders,
    this.userId,
  );
  List<OrderModel> get orders {
    return [..._orders];
  }

  bool isLoading = false;
  Future<void> addOrder(
    List<CartItem> cartProducts,
    double totalAmunt,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      final url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
      final dateTime = DateTime.now();
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': totalAmunt,
            'dateTime': dateTime.toIso8601String(),
            'cartProducts':
                // [....]
                cartProducts
                    .map((singleCartProduct) => {
                          'id': singleCartProduct.id,
                          'title': singleCartProduct.title,
                          'quantity': singleCartProduct.quantity,
                          'price': singleCartProduct.price,
                        })
                    .toList(),
          }));

      _orders.insert(
        0,
        OrderModel(
          id: json.decode(response.body)['name'].toString(),
          amount: totalAmunt,
          cartProducts: cartProducts,
          dateTime: dateTime,
        ),
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getTheOrders() async {
    final List<OrderModel> _loadedOrdersFromServer = [];
    try {
      final url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
      final response = await http.get(Uri.parse(url));
      //print(json.decode(response.body));
      final _extractedData = json.decode(response.body) as Map<String, dynamic>;
      final _extractedCartItemData = json.decode(response.body)['cartProducts'];

      _extractedData.forEach((orderId, orderData) {
        _loadedOrdersFromServer.add(
          OrderModel(
              id: orderId,
              amount: orderData['amount'],
              cartProducts: (orderData['cartProducts'] as List<dynamic>)
                  .map(
                    (cartItem) => CartItem(
                      id: cartItem['id'],
                      title: cartItem['title'],
                      quantity: cartItem['quantity'],
                      price: cartItem['price'],
                    ),
                  )
                  .toList(),
              dateTime: DateTime.parse(orderData['dateTime'])),
        );
      });
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      notifyListeners();
    }
    _orders = _loadedOrdersFromServer.reversed.toList();
    // // ignore: avoid_print
    // print(_orders[0].cartProducts);
    // // ignore: avoid_print
    // print(_orders[1].cartProducts);
    notifyListeners();
  }
}
