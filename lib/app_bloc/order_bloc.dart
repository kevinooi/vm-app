import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/models/graphQLConf.dart';
import 'package:merchant_app/models/order.dart';

import 'order_services.dart';

class OrderBloc with ChangeNotifier{
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  OrderServices get service => GetIt.I<OrderServices>();
  Future<Map<int, List<Order>>> futureOrderList;
  
  Future<Order> futureOrder;
  String _id;
  String get id => _id;
  set id(String id) {
    _id = id;
    futureOrder = service.getOrder(id);
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<Map<int, List<Order>>> _future;
  Future<Map<int, List<Order>>> get future => _future;
  set future(Future<Map<int, List<Order>>> future) {
    _future = future;
    notifyListeners();
    print('future');
  }

  Future<Map<int, List<Order>>> fetchNew(int start)async {
    final newList = await service.getAllOrders(start: start);
    print('fetchNew');
    print(start);
    isLoading = false;
    return newList;
  }

  OrderBloc() {
    futureOrderList = service.getAllOrders();
    future = service.getAllOrders();
  }
}