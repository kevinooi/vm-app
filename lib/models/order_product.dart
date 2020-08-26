import 'package:merchant_app/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_product.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)

class OrderProduct {
  OrderProduct({
    this.id,
    this.product,
  });

  String id;
  Product product;

  factory OrderProduct.fromJson(Map<String, dynamic> json) => _$OrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}