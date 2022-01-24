import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week11_add_to_cart_app/constants.dart';
import 'package:week11_add_to_cart_app/products_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
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
          //если продукт был добавлен в корзину,
          //показывается сообщение, предусмотренное соответствующим событием
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
                //иконка тележки с количеством добавленных продуктов
                icon: _cartWithBadge(context, productsState.inCartValue)
              );
            }
          ),
        ],
      ),
      //список ListTile с продуктами
      body: ListView.builder(
        itemCount: numOfProducts,
        itemBuilder: ((BuildContext context, int index) {
          return BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, ProductsState productsState) {
                return ListTile(
                  leading: Icon(
                    Icons.flourescent_rounded,
                    //цвета иконок слева продуктов меняются по списку Colors.primaries
                    //если продуктов больше, чем цветов в списке, цвета идут заново
                    color: Colors.primaries[index % Colors.primaries.length],
                  ),
                  title: Text('Product $index'),
                  trailing: GestureDetector(
                    //иконки справа продуктов и действия по тапу на них
                    //зависят от того, находится ли продукт index в корзине
                    child: Icon((productsState.productsList)[index]
                        ? Icons.shopping_cart
                        : Icons.shopping_cart_outlined),
                    onTap: () {
                      if ((productsState.productsList)[index]) {
                        context.read<ProductsBloc>().add(ProductsDeleted(index: index));
                      } else {
                        context.read<ProductsBloc>().add(ProductsAdded(index: index));
                      }
                    },
                  ),
                );
              }
          );
        })
      )
    );
  }
}

//иконка тележки с количеством добавленных продуктов number
//number показывается в красном бейдже сверху справа
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