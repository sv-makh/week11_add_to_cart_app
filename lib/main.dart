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
      debugShowCheckedModeBanner: false,
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
        actions: [
          BlocConsumer<ProductsBloc, ProductsState>(
            listenWhen: (ProductsState previous, ProductsState current) {
              if (current.addedToCart == true) {
                return true;
              } else {
                return false;
              }
            },
            listener: (context, ProductsState state) {
              final snackBar = SnackBar(content: Text("Product was added to a cart"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            builder: (context, ProductsState productsState) {
              return IconButton(
                onPressed: () {},
                icon: _cartWithBadge(context, productsState.inCartValue)
              );
            }
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.flourescent_rounded,
              color: Colors.deepOrange,
            ),
            title: Text('Product 0'),
            trailing: GestureDetector(
              child: Icon(Icons.shopping_cart_outlined),
              onTap: () => context.read<ProductsBloc>().add(ProductsAdded()),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.flourescent_rounded,
              color: Colors.deepOrange,
            ),
            title: Text('Product 1'),
            trailing: GestureDetector(
              child: Icon(Icons.shopping_cart_outlined),
              onTap: () => context.read<ProductsBloc>().add(ProductsAdded()),
            ),
          ),
        ],
      )
    );
  }
}

class ProductsEvent {}

class ProductsAdded extends ProductsEvent {}

class ProductsState {
  final int inCartValue;
  final bool addedToCart;
  ProductsState({required this.inCartValue, this.addedToCart = false});
}

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState(inCartValue: 0)) {
    on<ProductsAdded>((ProductsEvent event, Emitter<ProductsState> emitter) =>
      emitter(ProductsState(inCartValue: state.inCartValue + 1, addedToCart: true))
    );
  }
}

Widget _cartWithBadge(BuildContext context, int number) {
  return InkWell(
    child: Container(
      width: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(children: [
            SizedBox(height: 10),
            Icon(Icons.shopping_cart)
          ]),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              alignment: Alignment.center,
              child: Text('$number', style: TextStyle(fontSize: 12),),
            ),
          )
        ],
      ),
    )
  );
}