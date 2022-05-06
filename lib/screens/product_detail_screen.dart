import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/single_product_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/prodct-detail';

  @override
  Widget build(BuildContext context) {
    final Object? productId = ModalRoute.of(context)?.settings.arguments;
    final Product productLoaded =
        Provider.of<ProductsProvider>(context).findById(productId as String);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productLoaded.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(productLoaded.imageUrl),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            productLoaded.title,
            style: const TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            "Description : ${productLoaded.description}",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
            softWrap: true,
          ),
        ]),
      ),
    );
  }
}
