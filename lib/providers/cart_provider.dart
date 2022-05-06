import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};
  // {
  //   id of Product : Object of CartItem
  //   1:CartItem,
  //   2:CartItem,
  // }

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

// Add To Cart
  void addItemToCart(
    String productID,
    double price,
    String title,
  ) {
    // To Check if the product is already in Cart or Not
    if (_cartItems.containsKey(productID)) {
      // Change Quantaity
      _cartItems.update(
          productID,
          (oldCartItem) => CartItem(
                id: oldCartItem.id,
                title: oldCartItem.title,
                quantity: oldCartItem.quantity + 1,
                price: oldCartItem.price,
              ));
    } else {
      _cartItems.putIfAbsent(
        productID,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  int get itemCount {
    if (_cartItems == null) {
      return 0;
    }
    return _cartItems.length;
  }

  double get totalAmount {
    var _totalAm = 0.0;
    _cartItems.forEach((key, value) {
      _totalAm += value.quantity * value.price;
    });
    return _totalAm;
  }

  void deleteFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }

  void undoAddToCart(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    } else if (_cartItems[productId]!.quantity > 1) {
      _cartItems.update(
          productId,
          (oldItem) => CartItem(
              id: oldItem.id,
              title: oldItem.title,
              quantity: oldItem.quantity - 1,
              price: oldItem.price));
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }
}
