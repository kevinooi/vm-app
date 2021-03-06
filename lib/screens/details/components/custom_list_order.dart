import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/order_bloc.dart';
import 'package:merchant_app/app_bloc/order_services.dart';
import 'package:merchant_app/models/graphQLConf.dart';
import 'package:merchant_app/models/order.dart';
import 'package:provider/provider.dart';

class CustomListOrder extends StatefulWidget {
  final String name;
  CustomListOrder({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  _CustomListOrderState createState() => _CustomListOrderState();
}

class _CustomListOrderState extends State<CustomListOrder> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  OrderServices get service => GetIt.I<OrderServices>();

  @override
  Widget build(BuildContext context) {
    
    OrderBloc orderBloc = context.watch<OrderBloc>();
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Order>(
        future: orderBloc.futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return new ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.orderProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                        snapshot.data.orderProducts[index]?.product?.name ??
                            ""),
                    subtitle: Text(
                        'Amount: ${snapshot.data.orderProducts[index]?.product?.quantity ?? ""}'),
                    trailing: Text(
                        'RM ${snapshot.data.orderProducts[index]?.product?.price ?? ""}'),
                    onTap: () {},
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
