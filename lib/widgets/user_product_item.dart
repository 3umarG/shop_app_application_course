import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;

  const UserProductItem({
    required this.imageUrl,
    required this.title,
    required this.productId,
  });
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: productId,
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.amber,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(
                        context,
                        listen: false,
                      ).deleteProduct(productId).then((value) {
                        scaffold.showSnackBar(
                          const SnackBar(
                            content: Text("Deleted Succefully..!!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                    } catch (error) {
                      scaffold.showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Can't Delete the Product...!!")));
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    ;
  }
}
