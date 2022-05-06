import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavoriteStatus(
    String productId,
    Product product,
    String authToken,
    String userId,
  ) async {
    // 1-Change the UI
    //.............
    isFavourite = !isFavourite;
    try {
      final url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/userFavourites/$userId/$productId.json?auth=$authToken';
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException("Add To Fav Exceprion");
      }
    } catch (e) {
      print(e);
      isFavourite = !isFavourite;
      notifyListeners();
      rethrow;
    }
    notifyListeners();
  }
}


/*
Future<void> changeFavuriteSatus(String id, Product product) async {
    try {
      final url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavourite': !product.isFavourite,
          }));
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      notifyListeners();
    }
    // _productsList[productIndex] = product;
  }

*/