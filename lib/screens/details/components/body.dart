import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/order_services.dart';
import 'package:merchant_app/models/order.dart';
import 'package:merchant_app/navigation_service.dart';

import 'custom_list_order.dart';
import 'item.dart';

class Body extends StatefulWidget {
  final String id;

  Body(this.id);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  OrderServices get service => GetIt.I<OrderServices>();
  NavigationService get navigator => GetIt.I<NavigationService>();
  Order futureOrder;

  @override
  void initState() {
    super.initState();
    initOrder();
  }

  Order singleOrder;
  void initOrder() async {
    final order = await service.getOrder(widget.id);
    if (this.mounted) {
      setState(() {
        singleOrder = order;
      });
    }
  }

  void showToastPaid() {
    Fluttertoast.showToast(
        msg: 'Order Status : Paid',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.black);
  }

  void showToastRejected() {
    Fluttertoast.showToast(
        msg: 'Order Status : Rejected',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Reject Order?'),
            content: new Text('Are you sure you want to reject this order?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () async {
                  futureOrder = await service.rejectOrder(widget.id);
                  navigator.maybePop();
                  showToastRejected();
                },
                child: new Text('Yes'),
              ),
              new FlatButton(
                  onPressed: () {
                    navigator.maybePop();
                  },
                  child: new Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        // SizedBox(height: 10),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
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
                // padding: EdgeInsets.only(top: 20),
                child: Item(
                  orderNumber: singleOrder?.orderNumber ?? "",
                  createdAt: singleOrder?.createdAt,
                ),
              ),
              Container(
                  child: CustomListOrder(),
                ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: size.width / 2,
                      height: 70,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                          ),
                        ),
                        color: Color(0xFF0C9869),
                        onPressed: () async {
                          futureOrder =
                              await service.updateOrderStatus(widget.id);
                          showToastPaid();
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 2,
                      height: 70,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                          ),
                        ),
                        color: Colors.white,
                        onPressed: () async {
                          _showDialog();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
