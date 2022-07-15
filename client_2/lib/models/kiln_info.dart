import 'package:json_annotation/json_annotation.dart';
import 'package:kiln_controller/models/epoch_serializer.dart';

part 'kiln_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class KilnInfo {
  final String name;
  final List<dynamic> users;
  final bool isPremium;
  final KilnStatus status;
  final KilnConfig config;
  final KilnProgram program;
  final bool logRequest;
  final String macAddress;
  final String serialNumber;
  final String firmwareVersion;
  final String product;
  final String externalId;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  final int firingsCount;
  final DateTime isPremiumUpdated;
  @EpochDatetimeSerializer()
  final DateTime latestFiringStartTime;
  final LatestFiring latestFiring;

  KilnInfo({
    required this.name,
    required this.users,
    required this.isPremium,
    required this.status,
    required this.config,
    required this.program,
    required this.logRequest,
    required this.macAddress,
    required this.serialNumber,
    required this.firmwareVersion,
    required this.product,
    required this.externalId,
    required this.createdAt,
    required this.updatedAt,
    required this.firingsCount,
    required this.isPremiumUpdated,
    required this.latestFiringStartTime,
    required this.latestFiring,
  });

  factory KilnInfo.fromJson(Map<String, dynamic> json) => _$KilnInfoFromJson(json);
  Map<String, dynamic> toJson() => _$KilnInfoToJson(this);
  
  bool get connected => DateTime.now().difference(updatedAt.toLocal())
      .inSeconds < 5;

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class KilnStatus {
  @JsonKey(name: '_id')
  final String id;
  final String fw;
  // TODO enum (next 2)
  final String mode;
  final String alarm;
  final int numFire;
  final FiringStatus firing;
  final DiagStatus diag;
  final StatusError error;
  final int t1;
  final int t2;
  final int t3;
  double get temp => ((t1+t2+t3)/3);

  KilnStatus({
    required this.id,
    required this.fw,
    required this.mode,
    required this.alarm,
    required this.numFire,
    required this.firing,
    required this.diag,
    required this.error,
    required this.t1,
    required this.t2,
    required this.t3,
  });

  factory KilnStatus.fromJson(Map<String, dynamic> json) => _$KilnStatusFromJson(json);
  Map<String, dynamic> toJson() => _$KilnStatusToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FiringStatus {
  final int setPt;
  //TODO custom step parser
  final String step;
  final int fireMin;
  final int fireHour;
  final int holdMin;
  final int holdHour;
  final int startMin;
  final int startHour;
  final int cost;
  //TODO custom etr parser
  @JsonKey(name: 'etr')
  final String estimatedTimeRemaining;

  FiringStatus({
    required this.setPt,
    required this.step,
    required this.fireMin,
    required this.fireHour,
    required this.holdMin,
    required this.holdHour,
    required this.startMin,
    required this.startHour,
    required this.cost,
    required this.estimatedTimeRemaining,
  });

  factory FiringStatus.fromJson(Map<String, dynamic> json) => _$FiringStatusFromJson(json);
  Map<String, dynamic> toJson() => _$FiringStatusToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DiagStatus {
  final int a1;
  final int a2;
  final int a3;
  final int nl;
  final int fl;
  final int v1;
  final int v2;
  final int v3;
  final int vs;
  final int boardT;
  final int lastErr;
  final DateTime date;

  DiagStatus({
    required this.a1,
    required this.a2,
    required this.a3,
    required this.nl,
    required this.fl,
    required this.v1,
    required this.v2,
    required this.v3,
    required this.vs,
    required this.boardT,
    required this.lastErr,
    required this.date,
  });

  factory DiagStatus.fromJson(Map<String, dynamic> json) => _$DiagStatusFromJson(json);
  Map<String, dynamic> toJson() => _$DiagStatusToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StatusError {
  final String errText;
  final int errNum;

  StatusError({
    required this.errText,
    required this.errNum,
  });

  factory StatusError.fromJson(Map<String, dynamic> json) => _$StatusErrorFromJson(json);
  Map<String, dynamic> toJson() => _$StatusErrorToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class KilnConfig {
  @JsonKey(name: '_id')
  final String id;
  final String errCodes;
  final String tScale;
  final int noLoad;
  final int fullLoad;
  final int numZones;

  KilnConfig({
    required this.id,
    required this.errCodes,
    required this.tScale,
    required this.noLoad,
    required this.fullLoad,
    required this.numZones,
  });

  factory KilnConfig.fromJson(Map<String, dynamic> json) => _$KilnConfigFromJson(json);
  Map<String, dynamic> toJson() => _$KilnConfigToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class KilnProgram {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String type;
  final int alarmT;
  final String speed;
  final String cone;
  final int numSteps;
  final List<ProgramStep> steps;

  KilnProgram({
    required this.id,
    required this.name,
    required this.type,
    required this.alarmT,
    required this.speed,
    required this.cone,
    required this.numSteps,
    required this.steps,
  });

  factory KilnProgram.fromJson(Map<String, dynamic> json) => _$KilnProgramFromJson(json);
  Map<String, dynamic> toJson() => _$KilnProgramToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProgramStep {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 't')
  final int temp;
  final int hr;
  final int mn;
  final int rt;
  final int num;

  ProgramStep({
    required this.id,
    required this.temp,
    required this.hr,
    required this.mn,
    required this.rt,
    required this.num,
  });

  factory ProgramStep.fromJson(Map<String, dynamic> json) => _$ProgramStepFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramStepToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LatestFiring {
  final bool ended;
  final bool justEnded;
  @EpochDatetimeSerializer()
  final DateTime startTime;
  @EpochDatetimeSerializer()
  final DateTime updateTime;
  @EpochDatetimeSerializer()
  final DateTime? endedTime;

  LatestFiring({
    required this.ended,
    required this.justEnded,
    required this.startTime,
    required this.updateTime,
    required this.endedTime,
  });

  factory LatestFiring.fromJson(Map<String, dynamic> json) => _$LatestFiringFromJson(json);
  Map<String, dynamic> toJson() => _$LatestFiringToJson(this);

  @override
  String toString() => toJson().toString();
}
