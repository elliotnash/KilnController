import 'package:json_annotation/json_annotation.dart';

class EpochDatetimeSerializer implements JsonConverter<DateTime, String> {
  const EpochDatetimeSerializer();
  DateTime fromJson(String date) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(date), isUtc: true);
  String toJson(DateTime date) =>
      date.toUtc().millisecondsSinceEpoch.toString();
}
