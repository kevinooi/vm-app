// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'] as String,
    orderNumber: json['order_number'] as String,
    orderedBy: json['ordered_by'] == null
        ? null
        : OrderedBy.fromJson(json['ordered_by'] as Map<String, dynamic>),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    orderProducts: (json['order_products'] as List)
        ?.map((e) =>
            e == null ? null : OrderProduct.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'ordered_by': instance.orderedBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'order_products': instance.orderProducts,
    };
