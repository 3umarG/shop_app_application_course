import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/our_products_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider?>(
          create: (context) => null,
          update: (context, authProvider, previousProvider) => OrderProvider(
            authProvider.token,
            previousProvider == null ? [] : previousProvider.orders,
            authProvider.userId,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider?>(
          create: (context) => null,
          update: (context, AuthProvider auth, previousProvider) =>
              ProductsProvider(
            auth.token,
            auth.userId,
            previousProvider == null ? [] : previousProvider.items,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.red),
            fontFamily: 'Lato',
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontSize: 25,
                fontFamily: 'RobotoMono',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              // headline6: TextStyle(
              //   fontSize: 40.0,
              //   fontStyle: FontStyle.italic,
              // ),
              bodyText2: TextStyle(
                fontSize: 25.0,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
          home: authProvider.isAuthed
              ? const ProductsOverViewScreen()
              : FutureBuilder(
                  future: authProvider.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            OurProductsScreen.routeName: (context) => const OurProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            ProductsOverViewScreen.productsOverViewScreenRoute: (context) =>
                const ProductsOverViewScreen(),
            //AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
