import 'package:json_annotation/json_annotation.dart';

import 'order_product.dart';
import 'ordered_by.dart';

part 'order.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Order {
  final String id;
  final String orderNumber;
  final OrderedBy orderedBy;
  final DateTime createdAt;
  final List<OrderProduct> orderProducts;

  Order({
    this.id,
    this.orderNumber,
    this.orderedBy,
    this.createdAt,
    this.orderProducts,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

}

