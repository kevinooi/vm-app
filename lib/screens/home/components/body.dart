import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/order_bloc.dart';
import 'package:merchant_app/app_bloc/order_services.dart';
import 'package:merchant_app/models/graphQLConf.dart';
import 'package:merchant_app/models/order.dart';
import 'package:merchant_app/screens/details/details_screen.dart';
import 'package:provider/provider.dart';

import 'order_card.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  OrderServices get service => GetIt.I<OrderServices>();
  bool isLoading = false;
  List<Order> _list;
  int listCount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Builder(
        builder: (BuildContext newContext) {
          OrderBloc orderBloc = newContext.watch<OrderBloc>();
          return Column(
            children: <Widget>[
              SizedBox(height: 10),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // Background
                    Container(
                      margin: EdgeInsets.only(top: 70),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 40),
                      child: FutureBuilder<Map<int, List<Order>>>(
                        future: orderBloc.future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              // print(snapshot.data[0].id);

                              // setState(() {
                              //   listCount = snapshot.data?.entries?.first?.key ?? -1;
                              // });
                              final incomingList =
                                  snapshot.data?.entries?.first?.value ?? null;

                              if (_list == null) {
                                addItem(incomingList);
                              }
                              // else if ((snapshot.data?.isNotEmpty ?? false)) {
                              //   incomingList.forEach((element) {
                              //     final check =
                              //         _list.where((element2) => element2.id == element.id);
                              //     if (check.isEmpty) {
                              //       _list.add(element);
                              //     }
                              //   });
                              // }
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                          }

                          // loading
                          if ((_list?.length ?? 0) > 0) {
                            return NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (((_list
                                                ?.length ??
                                            -1) <
                                        (snapshot
                                                .data?.entries?.first?.key ??
                                            -1)) &&
                                    scrollInfo.metrics.pixels <=
                                        scrollInfo.metrics.maxScrollExtent -
                                            10 &&
                                    !orderBloc.isLoading) {
                                  print('scrollMaxDetected');
                                  // orderBloc.isLoading = true;
                                  getOrders(orderBloc);
                                  // orderBloc.isLoading = false;
                                }
                                return true;
                              },
                              child: new RefreshIndicator(
                                onRefresh: () async {
                                  await getOrders(orderBloc, refresh: true);
                                  // return null;
                                },
                                child: ListView.builder(
                                    itemCount: _list.length +
                                        (orderBloc.isLoading ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == _list.length) {
                                        return Align(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator());
                                      }
                                      return OrderCard(
                                        itemIndex: index,
                                        orderNumber: _list[index].orderNumber,
                                        createdAt: _list[index].createdAt,
                                        press: () {
                                          SchedulerBinding.instance
                                              .addPostFrameCallback(
                                            (_) {
                                              orderBloc.id = _list[index].id;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsScreen()),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }),
                              ),
                            );
                          }
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // FutureBuilder<Map<int, List<Order>>> buildFutureBuilder() {}

  getOrders(
    OrderBloc orderBloc, {
    bool refresh: false,
  }) {
    orderBloc.isLoading = true;
    Future.delayed(Duration(seconds: 1), () async {
      int start = _list?.length ?? 0;
      if (refresh) {
        if (this.mounted) {
          setState(() {
            _list = [];
          });
        }
        start = 0;
      }

      final newList = await orderBloc.fetchNew(start);
      print(newList);
      final incomingList = newList?.entries?.first?.value ?? null;

      _list.addAll(incomingList);
    });
  }

  addItem(List<Order> orders) {
    // print(_list.length);
    if (_list == null) {
      _list = [...orders];
    } else {
      _list.addAll(orders);
      // print(_list.length);
    }
  }
}
