import 'package:json_annotation/json_annotation.dart';

part 'ordered_by.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)

class OrderedBy {
  OrderedBy({
    this.username,
  });

  String username;

  factory OrderedBy.fromJson(Map<String, dynamic> json) => _$OrderedByFromJson(json);

  Map<String, dynamic> toJson() => _$OrderedByToJson(this);
}
