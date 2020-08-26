import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key key,
    this.itemIndex,
    this.press, 
    this.orderNumber, 
    this.createdAt,
  }) : super(key: key);

  final int itemIndex;
  final Function press;
  final String orderNumber;
  final DateTime createdAt;
  
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

  String formatDay(DateTime dateTime) {
    if (dateTime != null) {
      return DateFormat("dd/MM/yyyy").format(dateTime);
    }
    return "";
  }

  String formatTime(DateTime dateTime) {
    if (dateTime != null) {
      return DateFormat("hh:mma").format(dateTime);
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical : 10
      ),
      height: 110,
      child: InkWell(
        onTap: widget.press,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Background
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: widget.itemIndex.isEven ? Color(0xFF40BAD5) : Color(0xFFFFA41B),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 15),
                    blurRadius: 27,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 120,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Order Number: ${widget.orderNumber?? ""}",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.itemIndex.isEven ? Color(0xFF40BAD5) : Color(0xFFFFA41B),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        "Date: ${formatDay(widget.createdAt)}\nTime: ${formatTime(widget.createdAt) ?? ""}",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
