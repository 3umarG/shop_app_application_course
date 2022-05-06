// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/21.1%20badge.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../widgets/products_grid.dart';

enum ProductsType {
  Favourite,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  const ProductsOverViewScreen({Key? key}) : super(key: key);

  static const productsOverViewScreenRoute = "/products-overview-screen";

  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool _showFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  // @override
  // void initState() {
  //   // WON'T WORK BECAUSE NO CONTEXT
  //   // Provider.of<ProductsProvider>(context).getProductsData();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      Provider.of<ProductsProvider>(context).getProductsData().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My ShopApp"),
        actions: [
          PopupMenuButton(
            onSelected: (ProductsType selectedItem) {
              if (mounted) {
                setState(
                  () {
                    if (selectedItem == ProductsType.Favourite) {
                      _showFavoritesOnly = true;
                    } else {
                      _showFavoritesOnly = false;
                    }
                  },
                );
              }
            },
            icon: const Icon(
              Icons.more_horiz,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text(
                  "Only Fav",
                ),
                value: ProductsType.Favourite,
              ),
              const PopupMenuItem(
                child: Text(
                  "All Products",
                ),
                value: ProductsType.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (BuildContext context, cartData, Widget? child) => Badge(
              child: child!,
              value: cartData.itemCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(
              showFav: _showFavoritesOnly,
            ),
    );
  }
}
