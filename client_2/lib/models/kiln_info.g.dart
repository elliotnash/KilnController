// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiln_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KilnInfo _$KilnInfoFromJson(Map<String, dynamic> json) => KilnInfo(
      name: json['name'] as String,
      users: json['users'] as List<dynamic>,
      isPremium: json['is_premium'] as bool,
      status: KilnStatus.fromJson(json['status'] as Map<String, dynamic>),
      config: KilnConfig.fromJson(json['config'] as Map<String, dynamic>),
      program: KilnProgram.fromJson(json['program'] as Map<String, dynamic>),
      logRequest: json['log_request'] as bool,
      macAddress: json['mac_address'] as String,
      serialNumber: json['serial_number'] as String,
      firmwareVersion: json['firmware_version'] as String,
      product: json['product'] as String,
      externalId: json['external_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      firingsCount: json['firings_count'] as int,
      isPremiumUpdated: DateTime.parse(json['is_premium_updated'] as String),
      latestFiringStartTime: const EpochDatetimeSerializer()
          .fromJson(json['latest_firing_start_time'] as String),
      latestFiring:
          LatestFiring.fromJson(json['latest_firing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KilnInfoToJson(KilnInfo instance) => <String, dynamic>{
      'name': instance.name,
      'users': instance.users,
      'is_premium': instance.isPremium,
      'status': instance.status,
      'config': instance.config,
      'program': instance.program,
      'log_request': instance.logRequest,
      'mac_address': instance.macAddress,
      'serial_number': instance.serialNumber,
      'firmware_version': instance.firmwareVersion,
      'product': instance.product,
      'external_id': instance.externalId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'firings_count': instance.firingsCount,
      'is_premium_updated': instance.isPremiumUpdated.toIso8601String(),
      'latest_firing_start_time': const EpochDatetimeSerializer()
          .toJson(instance.latestFiringStartTime),
      'latest_firing': instance.latestFiring,
    };

KilnStatus _$KilnStatusFromJson(Map<String, dynamic> json) => KilnStatus(
      id: json['_id'] as String,
      fw: json['fw'] as String,
      mode: json['mode'] as String,
      alarm: json['alarm'] as String,
      numFire: json['num_fire'] as int,
      firing: FiringStatus.fromJson(json['firing'] as Map<String, dynamic>),
      diag: DiagStatus.fromJson(json['diag'] as Map<String, dynamic>),
      error: StatusError.fromJson(json['error'] as Map<String, dynamic>),
      t1: json['t1'] as int,
      t2: json['t2'] as int,
      t3: json['t3'] as int,
    );

Map<String, dynamic> _$KilnStatusToJson(KilnStatus instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fw': instance.fw,
      'mode': instance.mode,
      'alarm': instance.alarm,
      'num_fire': instance.numFire,
      'firing': instance.firing,
      'diag': instance.diag,
      'error': instance.error,
      't1': instance.t1,
      't2': instance.t2,
      't3': instance.t3,
    };

FiringStatus _$FiringStatusFromJson(Map<String, dynamic> json) => FiringStatus(
      setPt: json['set_pt'] as int,
      step: json['step'] as String,
      fireMin: json['fire_min'] as int,
      fireHour: json['fire_hour'] as int,
      holdMin: json['hold_min'] as int,
      holdHour: json['hold_hour'] as int,
      startMin: json['start_min'] as int,
      startHour: json['start_hour'] as int,
      cost: json['cost'] as int,
      estimatedTimeRemaining: json['etr'] as String,
    );

Map<String, dynamic> _$FiringStatusToJson(FiringStatus instance) =>
    <String, dynamic>{
      'set_pt': instance.setPt,
      'step': instance.step,
      'fire_min': instance.fireMin,
      'fire_hour': instance.fireHour,
      'hold_min': instance.holdMin,
      'hold_hour': instance.holdHour,
      'start_min': instance.startMin,
      'start_hour': instance.startHour,
      'cost': instance.cost,
      'etr': instance.estimatedTimeRemaining,
    };

DiagStatus _$DiagStatusFromJson(Map<String, dynamic> json) => DiagStatus(
      a1: json['a1'] as int,
      a2: json['a2'] as int,
      a3: json['a3'] as int,
      nl: json['nl'] as int,
      fl: json['fl'] as int,
      v1: json['v1'] as int,
      v2: json['v2'] as int,
      v3: json['v3'] as int,
      vs: json['vs'] as int,
      boardT: json['board_t'] as int,
      lastErr: json['last_err'] as int,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$DiagStatusToJson(DiagStatus instance) =>
    <String, dynamic>{
      'a1': instance.a1,
      'a2': instance.a2,
      'a3': instance.a3,
      'nl': instance.nl,
      'fl': instance.fl,
      'v1': instance.v1,
      'v2': instance.v2,
      'v3': instance.v3,
      'vs': instance.vs,
      'board_t': instance.boardT,
      'last_err': instance.lastErr,
      'date': instance.date.toIso8601String(),
    };

StatusError _$StatusErrorFromJson(Map<String, dynamic> json) => StatusError(
      errText: json['err_text'] as String,
      errNum: json['err_num'] as int,
    );

Map<String, dynamic> _$StatusErrorToJson(StatusError instance) =>
    <String, dynamic>{
      'err_text': instance.errText,
      'err_num': instance.errNum,
    };

KilnConfig _$KilnConfigFromJson(Map<String, dynamic> json) => KilnConfig(
      id: json['_id'] as String,
      errCodes: json['err_codes'] as String,
      tScale: json['t_scale'] as String,
      noLoad: json['no_load'] as int,
      fullLoad: json['full_load'] as int,
      numZones: json['num_zones'] as int,
    );

Map<String, dynamic> _$KilnConfigToJson(KilnConfig instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'err_codes': instance.errCodes,
      't_scale': instance.tScale,
      'no_load': instance.noLoad,
      'full_load': instance.fullLoad,
      'num_zones': instance.numZones,
    };

KilnProgram _$KilnProgramFromJson(Map<String, dynamic> json) => KilnProgram(
      id: json['_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      alarmT: json['alarm_t'] as int,
      speed: json['speed'] as String,
      cone: json['cone'] as String,
      numSteps: json['num_steps'] as int,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => ProgramStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KilnProgramToJson(KilnProgram instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'alarm_t': instance.alarmT,
      'speed': instance.speed,
      'cone': instance.cone,
      'num_steps': instance.numSteps,
      'steps': instance.steps,
    };

ProgramStep _$ProgramStepFromJson(Map<String, dynamic> json) => ProgramStep(
      id: json['_id'] as String,
      temp: json['t'] as int,
      hr: json['hr'] as int,
      mn: json['mn'] as int,
      rt: json['rt'] as int,
      num: json['num'] as int,
    );

Map<String, dynamic> _$ProgramStepToJson(ProgramStep instance) =>
    <String, dynamic>{
      '_id': instance.id,
      't': instance.temp,
      'hr': instance.hr,
      'mn': instance.mn,
      'rt': instance.rt,
      'num': instance.num,
    };

LatestFiring _$LatestFiringFromJson(Map<String, dynamic> json) => LatestFiring(
      ended: json['ended'] as bool,
      justEnded: json['just_ended'] as bool,
      startTime: const EpochDatetimeSerializer()
          .fromJson(json['start_time'] as String),
      updateTime: const EpochDatetimeSerializer()
          .fromJson(json['update_time'] as String),
      endedTime: _$JsonConverterFromJson<String, DateTime>(
          json['ended_time'], const EpochDatetimeSerializer().fromJson),
    );

Map<String, dynamic> _$LatestFiringToJson(LatestFiring instance) =>
    <String, dynamic>{
      'ended': instance.ended,
      'just_ended': instance.justEnded,
      'start_time': const EpochDatetimeSerializer().toJson(instance.startTime),
      'update_time':
          const EpochDatetimeSerializer().toJson(instance.updateTime),
      'ended_time': _$JsonConverterToJson<String, DateTime>(
          instance.endedTime, const EpochDatetimeSerializer().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
