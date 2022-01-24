import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week11_add_to_cart_app/constants.dart';

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
              if (current.cartInteraction == true) {
                return true;
              } else {
                return false;
              }
            },
            listener: (context, ProductsState state) {
              final snackBar = SnackBar(content: Text(state.cartEventMsg));
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
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, ProductsState productsState) {
              return ListTile(
                leading: Icon(
                  Icons.flourescent_rounded,
                  color: Colors.deepOrange,
                ),
                title: Text('Product 0'),
                trailing: GestureDetector(
                  child: Icon((productsState.productsList)[0] ? Icons.shopping_cart : Icons.shopping_cart_outlined),
                  onTap: () {
                    if ((productsState.productsList)[0]) {
                      context.read<ProductsBloc>().add(ProductsDeleted(index: 0));
                    } else {
                      context.read<ProductsBloc>().add(ProductsAdded(index: 0));
                    }
                  },
                ),
              );
            }
          ),
          BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, ProductsState productsState) {
            return ListTile(
              leading: Icon(
                Icons.flourescent_rounded,
                color: Colors.deepOrange,
              ),
              title: Text('Product 1'),
              trailing: GestureDetector(
                child: Icon((productsState.productsList)[1] ? Icons.shopping_cart : Icons.shopping_cart_outlined),
                onTap: () {
                  if ((productsState.productsList)[1]) {
                    context.read<ProductsBloc>().add(ProductsDeleted(index: 1));
                  } else {
                    context.read<ProductsBloc>().add(ProductsAdded(index: 1));
                  }
                }
              ),
            );
          }),

        ],
      )
    );
  }
}

class ProductsEvent {}

class ProductsAdded extends ProductsEvent {
  int index;
  ProductsAdded({required this.index});
}

class ProductsDeleted extends ProductsEvent {
  int index;
  ProductsDeleted({required this.index});
}

class ProductsState {
  final int inCartValue;
  final bool cartInteraction;
  final String cartEventMsg;
  final List<bool> productsList;

  ProductsState({
    required this.inCartValue,
    this.cartInteraction = false,
    this.cartEventMsg = '',
    productsList
  }) : productsList = productsList ?? List<bool>.filled(numOfProducts, false);
}

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState(inCartValue: 0)) {
    on<ProductsAdded>((ProductsAdded event, Emitter<ProductsState> emitter) {
      List<bool> list = state.productsList;
      list[event.index] = true;
      return emitter(ProductsState(
          inCartValue: state.inCartValue + 1,
          cartInteraction: true,
          cartEventMsg: 'Product was added',
          productsList: list
      ));
    });

    on<ProductsDeleted>((ProductsDeleted event, Emitter<ProductsState> emitter) {
      List<bool> list = state.productsList;
      list[event.index] = false;
      return emitter(ProductsState(
        inCartValue: state.inCartValue - 1,
        cartInteraction: true,
        cartEventMsg: 'Product was deleted',
        productsList: list
      ));
    });
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