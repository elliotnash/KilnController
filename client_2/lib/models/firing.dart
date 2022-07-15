import 'package:json_annotation/json_annotation.dart';
import 'package:kiln_controller/models/epoch_serializer.dart';

part 'firing.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Firing {
  final String uuid;
  @EpochDatetimeSerializer()
  final DateTime time;

  Firing({
    required this.uuid,
    required this.time,
  });

  factory Firing.fromJson(Map<String, dynamic> json) => _$FiringFromJson(json);
  Map<String, dynamic> toJson() => _$FiringToJson(this);

  @override
  String toString() => toJson().toString();
}
