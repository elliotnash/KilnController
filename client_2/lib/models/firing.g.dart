// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Firing _$FiringFromJson(Map<String, dynamic> json) => Firing(
      uuid: json['uuid'] as String,
      time: const EpochDatetimeSerializer().fromJson(json['time'] as String),
    );

Map<String, dynamic> _$FiringToJson(Firing instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'time': const EpochDatetimeSerializer().toJson(instance.time),
    };
