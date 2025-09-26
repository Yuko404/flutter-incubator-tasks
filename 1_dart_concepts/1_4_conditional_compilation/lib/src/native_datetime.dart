import '_custom_datetime_class.dart';

class CustomDateTime extends AbstractCustomDateTime {
  CustomDateTime._(this.instance);

  @override
  final DateTime instance;

  factory CustomDateTime.now() {
    return CustomDateTime._(DateTime.now());
  }

  factory CustomDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    return CustomDateTime._(
      DateTime(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      ),
    );
  }

  factory CustomDateTime.utc(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    return CustomDateTime._(
      DateTime.utc(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      ),
    );
  }

  @override
  CustomDateTime toLocal() => CustomDateTime._(instance.toLocal());
  @override
  CustomDateTime toUtc() => CustomDateTime._(instance.toUtc());
  @override
  CustomDateTime add(Duration duration) =>
      CustomDateTime._(instance.add(duration));
  @override
  CustomDateTime subtract(Duration duration) =>
      CustomDateTime._(instance.subtract(duration));

  @override
  Duration difference(DateTime other) => instance.difference(other);

  factory CustomDateTime.fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    bool isUtc = false,
  }) => CustomDateTime._(
    DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: isUtc),
  );

  factory CustomDateTime.fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    bool isUtc = false,
  }) => CustomDateTime._(
    DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: isUtc),
  );

  factory CustomDateTime.parse(String formattedString) =>
      CustomDateTime._(DateTime.parse(formattedString));

  @override
  bool isBefore(DateTime other) => instance.isBefore(other);
  @override
  bool isAfter(DateTime other) => instance.isAfter(other);
  @override
  bool isAtSameMomentAs(DateTime other) => instance.isAtSameMomentAs(other);

  @override
  int compareTo(DateTime other) => instance.compareTo(other);

  @override
  String toIso8601String() => instance.toIso8601String();

  @override
  String toString() => instance.toString();

  @override
  bool operator ==(Object other) {
    if (other is CustomDateTime) {
      return microsecondsSinceEpoch == other.microsecondsSinceEpoch &&
          isUtc == other.isUtc;
    }
    return false;
  }
}
