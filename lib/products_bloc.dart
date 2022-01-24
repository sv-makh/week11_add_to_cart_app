import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week11_add_to_cart_app/constants.dart';

//события, которые могут произойти с продуктом:
class ProductsEvent {}

//добавление продукта index в корзину
class ProductsAdded extends ProductsEvent {
  int index;
  ProductsAdded({required this.index});
}

//удаление продукта index из корзины
class ProductsDeleted extends ProductsEvent {
  int index;
  ProductsDeleted({required this.index});
}

class ProductsState {
  //количество продуктов в корзине
  final int inCartValue;
  //была ли нажата иконка у продукта (добавление/удаление из корзины)
  final bool cartInteraction;
  //соответствующее сообщение о взаимодействии с продуктом
  final String cartEventMsg;
  //массив, каждый элемент которого обозначает,
  //есть ли продукт с соответствующим индексом в корзине
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
    //действия при каждом событии: изменить кол-во продуктов в корзине,
    //показать нужное сообщение, изменить состояние продукта в корзине (есть/нет)

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