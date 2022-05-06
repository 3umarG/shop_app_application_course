import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/providers/single_product_provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItemWidget extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItemWidget({
  //   Key? key,
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  // }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    // Listner
    final Product productProvider = Provider.of<Product>(
      context,
      listen: true,
    );
    final Cart cartProvider = Provider.of<Cart>(
      context,
      listen: false,
    );
    final authData = Provider.of<AuthProvider>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.purpleAccent,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: productProvider.id,
          ),
          child: Image.network(
            productProvider.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) {
              return IconButton(
                icon: child!,
                color: product.isFavourite ? Colors.red : Colors.white,
                onPressed: () async {
                  try {
                    await productProvider.toggleFavoriteStatus(
                      product.id,
                      product,
                      authData.token!,
                      authData.userId!,
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Row(
                          children: const [
                            Text("Change Succefully"),
                            Spacer(),
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    print(e);
                    scaffold.showSnackBar(
                      SnackBar(
                        content:
                            const Text("Can't change the Favourite Status"),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height - 100,
                            right: 20,
                            left: 20),
                      ),
                    );
                  }
                },
              );
              // child :
            },
            // Will Not Rebuild the Child Widget
            child: const Icon(
              Icons.favorite_outlined,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cartProvider.addItemToCart(
                productProvider.id,
                productProvider.price,
                productProvider.title,
              );
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Added to Cart Succefullt",
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cartProvider.undoAddToCart(productProvider.id);
                    },
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.shopify_outlined,
            ),
          ),
          title: Text(
            productProvider.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
