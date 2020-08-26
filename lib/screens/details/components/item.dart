import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Item extends StatefulWidget {
  const Item({
    Key key,
    this.orderNumber,
    this.createdAt,
  }) : super(key: key);

  final String orderNumber;
  final DateTime createdAt;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Order no: ${widget.orderNumber ?? ""}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            "Date: ${formatDay(widget.createdAt)}\nTime: ${formatTime(widget.createdAt)}",
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
