import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week11_add_to_cart_app/constants.dart';

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
          cartEventMsg: 'Added to cart',
          productsList: list
      ));
    });

    on<ProductsDeleted>((ProductsDeleted event, Emitter<ProductsState> emitter) {
      List<bool> list = state.productsList;
      list[event.index] = false;
      return emitter(ProductsState(
          inCartValue: state.inCartValue - 1,
          cartInteraction: true,
          cartEventMsg: 'Removed from cart',
          productsList: list
      ));
    });
  }
}