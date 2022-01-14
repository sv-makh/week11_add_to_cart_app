import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProductsScreen()
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsBloc(),
      child: const ProductsView(),
    );
  }
}

class ProductsView extends StatelessWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App'),
      ),
      body: Column(
        children: [
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, ProductsState productsState) {
              return Text('$productsState.inCartValue');
            }
          ),
          ListTile(
            leading: FlutterLogo(),
            title: Text('Product 0'),
            trailing: Icon(Icons.shopping_cart_outlined),
          ),
          ListTile(
            leading: FlutterLogo(),
            title: Text('Product 1'),
            trailing: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      )
    );
  }
}