import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class OurProductsScreen extends StatelessWidget {
  static const routeName = '/our-products-screen';

  const OurProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .getProductsData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text("Our Products "),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<ProductsProvider>(
                    builder:
                        (BuildContext context, productProvider, Widget? child) {
                      return RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: productProvider.items.length,
                            itemBuilder: (context, i) {
                              return UserProductItem(
                                productId: productProvider.items[i].id,
                                imageUrl: productProvider.items[i].imageUrl,
                                title: productProvider.items[i].title,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
