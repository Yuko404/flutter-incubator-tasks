import 'dart:convert';
import 'dart:io';
import 'package:duration/duration.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:toml/toml.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

part 'task.g.dart';

class DurationStringConverter extends JsonConverter<Duration, String> {
  const DurationStringConverter();

  @override
  Duration fromJson(String json) => parseDuration(json, separator: ',');

  @override
  String toJson(Duration duration) => duration.pretty(abbreviated: true);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Request {
  final String type;
  final StreamInfo stream;
  final List<Gift> gifts;
  final Debug debug;

  const Request({
    required this.type,
    required this.stream,
    required this.gifts,
    required this.debug,
  });

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  factory Request.fromJsonString(String jsonString) =>
      Request.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  factory Request.fromToml(String toml) =>
      Request.fromJson(TomlDocument.parse(toml).toMap());

  factory Request.fromYaml(String yaml) =>
      Request.fromJson(loadYaml(yaml) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$RequestToJson(this);

  String toToml() => TomlDocument.fromMap(toJson()).toString();

  String toYaml() => YamlWriter().write(toJson());
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Debug {
  @DurationStringConverter()
  final Duration duration;
  final DateTime at;

  const Debug({required this.duration, required this.at});

  factory Debug.fromJson(Map<String, dynamic> json) => _$DebugFromJson(json);

  Map<String, dynamic> toJson() => _$DebugToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Gift {
  final int id;
  final int price;
  final String description;

  const Gift({
    required this.id,
    required this.price,
    required this.description,
  });

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  Map<String, dynamic> toJson() => _$GiftToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class StreamInfo {
  final String userId;
  final bool isPrivate;
  final int settings;
  final Uri shardUrl;
  final PublicTariff publicTariff;
  final PrivateTariff privateTariff;

  const StreamInfo({
    required this.userId,
    required this.isPrivate,
    required this.settings,
    required this.shardUrl,
    required this.publicTariff,
    required this.privateTariff,
  });

  factory StreamInfo.fromJson(Map<String, dynamic> json) =>
      _$StreamInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StreamInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PrivateTariff {
  final int clientPrice;
  @DurationStringConverter()
  final Duration duration;
  final String description;

  const PrivateTariff({
    required this.clientPrice,
    required this.duration,
    required this.description,
  });

  factory PrivateTariff.fromJson(Map<String, dynamic> json) =>
      _$PrivateTariffFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateTariffToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PublicTariff {
  final int id;
  final int price;
  @DurationStringConverter()
  final Duration duration;
  final String description;

  const PublicTariff({
    required this.id,
    required this.price,
    required this.duration,
    required this.description,
  });

  factory PublicTariff.fromJson(Map<String, dynamic> json) =>
      _$PublicTariffFromJson(json);

  Map<String, dynamic> toJson() => _$PublicTariffToJson(this);
}

void main() {
  final File file = File(r'lib/request.json');
  final String fileText = file.readAsStringSync();
  final Request request = Request.fromJsonString(fileText);

  print('--- YAML Output ---');
  print(request.toYaml());

  print('--- TOML Output ---');
  print(request.toToml());
}
