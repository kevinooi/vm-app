import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/order_bloc.dart';
import 'package:merchant_app/models/order.dart';
import 'package:merchant_app/push_notifications.dart';
import 'package:provider/provider.dart';

class CustomListOrder extends StatefulWidget {
  CustomListOrder({
    Key key,
  }) : super(key: key);

  @override
  _CustomListOrderState createState() => _CustomListOrderState();
}

class _CustomListOrderState extends State<CustomListOrder> {
  PushNotifications get notifyService => GetIt.I<PushNotifications>();

  @override
  Widget build(BuildContext context) {
    OrderBloc orderBloc = context.watch<OrderBloc>();
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Order>(
        future: orderBloc.futureOrder ?? notifyService.futureOrder,
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
