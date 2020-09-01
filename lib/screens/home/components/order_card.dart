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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      height: 110,
      child: InkWell(
        onTap: widget.press,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Background
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color:
                    // widget.itemIndex.isEven ?
                    Color(0xFF40BAD5),
                // : Color(0xFFFFA41B),
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
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                // image is square but we add extra 20 + 20 padding thats why width is 200
                // width: 80,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 100,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "${formatDay(widget.createdAt)}",
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "\n    ${formatTime(widget.createdAt) ?? ""}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        )

                        // Text(
                        //   "Order Number: ${widget.orderNumber ?? ""}",
                        //   style: Theme.of(context).textTheme.button,
                        // ),
                        ),
                    Spacer(),
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 30,
                    //     vertical: 5,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: widget.itemIndex.isEven
                    //         ? Color(0xFF40BAD5)
                    //         : Color(0xFFFFA41B),
                    //     borderRadius: BorderRadius.only(
                    //       bottomLeft: Radius.circular(22),
                    //       topRight: Radius.circular(22),
                    //     ),
                    //   ),
                    //   child: Text(
                    //     "Date: ${formatDay(widget.createdAt)}\nTime: ${formatTime(widget.createdAt) ?? ""}",
                    //     style: Theme.of(context).textTheme.button,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: SizedBox(
                height: 100,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Spacer(),
                    Padding(
                        padding: const EdgeInsets.only(right : 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "${widget.orderNumber ?? ""}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        )),
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
