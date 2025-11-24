import 'package:duration/duration.dart' show parseDuration, PrettyDuration;

class DurationStringConverter {
  const DurationStringConverter();

  Duration fromJson(String json) => parseDuration(json, separator: ',');

  String toJson(Duration duration) => duration.pretty(abbreviated: true);
}
