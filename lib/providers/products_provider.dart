import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/single_product_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _productsList = [];

  final String? userId;
  ProductsProvider(
    this.authToken,
    this.userId,
    this._productsList,
  );

  List<Product> get items {
    return [..._productsList];
  }

  List<Product> get favItems {
    return _productsList.where((element) => element.isFavourite).toList();
  }

  Future<void> addProductWithThen(Product product) {
// create folder in firebase Server for store the products by JSON Form...
    final url =
        'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    // HTTP Request Action
    return http
        .post(
      // To give the Place (Direction)...
      Uri.parse(url),
      // Body : The Object or Data you Push or Post to the Direction
      body: json.encode({
        "title": product.title,
        "description": product.description,
        "imageUrl": product.imageUrl,
        "price": product.price,
        "userId": userId,
      }),
    )
        .then((response) {
      // print(response.body);
      Product newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _productsList.add(newProduct);
      notifyListeners();
    }).catchError((e) {
      // ignore: avoid_print
      //print(e);
      // I make throw because I will use this error
      // in The Widget UI ......
      throw e;
    });
  }

  Future<void> addProductWithAsync(Product product) async {
    try {
      // create folder in firebase Server for store the products by JSON Form...
      final url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/products.json?auth=$authToken';
      // HTTP Request Action
      final response = await http.post(
        // To give the Place (Direction)...
        Uri.parse(url),
        // Body : The Object or Data you Push or Post to the Direction
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "userId": userId,
        }),
      );

      Product newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _productsList.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final int productIndex =
        _productsList.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
      _productsList[productIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final _deletedIndex =
        _productsList.indexWhere((element) => element.id == id);
    Product? _deletedProduct = _productsList[_deletedIndex];

    // 1-Deleted in UI
    _productsList.removeAt(_deletedIndex);
    notifyListeners();
    try {
      // 2-Try to Deleted from DataBase
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        throw HttpException("Status Code Exception");
      } else {
        _deletedProduct = null;
        print("Deleted Done!!!!");
      }
    } catch (error) {
      _productsList.insert(_deletedIndex, _deletedProduct!);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  final String? authToken;

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> getProductsData([final bool isFilter = false]) async {
    final queryFilter = isFilter ? 'orderBy="userId"&equalTo="$userId"' : '';
    try {
      var url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/products.json?auth=$authToken&$queryFilter';
      final response = await http.get(Uri.parse(url));
      final List<Product> loadedProducts = [];
      final Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      url =
          'https://shop-app-max-dcfd1-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final http.Response favResponse = await http.get(Uri.parse(url));
      print(favResponse.body);
      final favData = json.decode(favResponse.body);
      extractedData.forEach(
        (productId, productDetails) {
          loadedProducts.add(
            Product(
              id: productId,
              isFavourite:
                  favData == null ? false : favData[productId] ?? false,
              title: productDetails['title'],
              description: productDetails['description'],
              price: productDetails['price'],
              imageUrl: productDetails['imageUrl'],
            ),
          );
        },
      );
      _productsList = loadedProducts;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
