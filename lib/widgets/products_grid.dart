import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products_provider.dart';

import '../providers/single_product_provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  const ProductsGrid({
    Key? key,
    required this.showFav,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ProductsProvData = Provider.of<ProductsProvider>(context);
    final List<Product> productsList =
        showFav ? ProductsProvData.favItems : ProductsProvData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: productsList.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: productsList[index],
        child: ProductItemWidget(
            // id: productsList[index].id,
            // title: productsList[index].title,
            // imageUrl: productsList[index].imageUrl,
            ),
      ),
    );
  }
}
