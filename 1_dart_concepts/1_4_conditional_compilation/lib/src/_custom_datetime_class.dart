abstract class AbstractCustomDateTime implements DateTime {
  DateTime get instance;

  @override
  int get year => instance.year;
  @override
  int get month => instance.month;
  @override
  int get day => instance.day;
  @override
  int get hour => instance.hour;
  @override
  int get minute => instance.minute;
  @override
  int get second => instance.second;
  @override
  int get millisecond => instance.millisecond;
  @override
  int get microsecond => instance.microsecond;
  @override
  int get weekday => instance.weekday;
  @override
  bool get isUtc => instance.isUtc;
  @override
  String get timeZoneName => instance.timeZoneName;
  @override
  Duration get timeZoneOffset => instance.timeZoneOffset;
  @override
  int get millisecondsSinceEpoch => instance.millisecondsSinceEpoch;
  @override
  int get microsecondsSinceEpoch => instance.microsecondsSinceEpoch;

  @override
  int get hashCode => Object.hash(microsecondsSinceEpoch, isUtc);
}
