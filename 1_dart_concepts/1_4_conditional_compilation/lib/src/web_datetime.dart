import 'package:web/web.dart' as web;
import '_custom_datetime_class.dart';

String _two(int n) => n.toString().padLeft(2, '0');
String _three(int n) => n.toString().padLeft(3, '0');

class CustomDateTime extends AbstractCustomDateTime {
  final int extraMicrosecond;

  CustomDateTime._(this.instance, this.extraMicrosecond);

  @override
  final DateTime instance;

  factory CustomDateTime.now() {
    final performance = web.window.performance;
    final double timeOrigin = performance.timeOrigin;
    final double durationSinceOrigin = performance.now();
    final int nowMicrosecond = ((timeOrigin + durationSinceOrigin) * 1000)
        .round();
    return CustomDateTime.fromMicrosecondsSinceEpoch(nowMicrosecond);
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
      DateTime(year, month, day, hour, minute, second, millisecond),
      microsecond,
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
      DateTime.utc(year, month, day, hour, minute, second, millisecond),
      microsecond,
    );
  }

  factory CustomDateTime.fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    bool isUtc = false,
  }) => CustomDateTime._(
    DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: isUtc),
    0,
  );

  factory CustomDateTime.fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    bool isUtc = false,
  }) {
    int microsecond = microsecondsSinceEpoch % 1000;
    final DateTime instance = DateTime.fromMillisecondsSinceEpoch(
      microsecondsSinceEpoch ~/ 1000,
      isUtc: isUtc,
    );
    return CustomDateTime._(instance, microsecond);
  }

  @override
  int get microsecond => extraMicrosecond;

  @override
  int get microsecondsSinceEpoch {
    return instance.microsecondsSinceEpoch + microsecond;
  }

  @override
  CustomDateTime toLocal() {
    if (isUtc) {
      return CustomDateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: false,
      );
    }
    return this;
  }

  @override
  CustomDateTime toUtc() {
    if (isUtc) {
      return this;
    }
    return CustomDateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpoch,
      isUtc: true,
    );
  }

  @override
  CustomDateTime add(Duration duration) {
    final totalMicro = microsecondsSinceEpoch + duration.inMicroseconds;
    return CustomDateTime.fromMicrosecondsSinceEpoch(totalMicro, isUtc: isUtc);
  }

  @override
  CustomDateTime subtract(Duration duration) {
    final totalMicro = microsecondsSinceEpoch - duration.inMicroseconds;
    return CustomDateTime.fromMicrosecondsSinceEpoch(totalMicro, isUtc: isUtc);
  }

  @override
  Duration difference(DateTime other) {
    final int diff = microsecondsSinceEpoch - other.microsecondsSinceEpoch;
    return Duration(microseconds: diff);
  }

  @override
  bool isBefore(DateTime other) {
    if (other is CustomDateTime) {
      return microsecondsSinceEpoch < other.microsecondsSinceEpoch;
    }
    throw Exception('Comparison with non-CustomDateTime is not supported');
  }

  @override
  bool isAfter(DateTime other) {
    if (other is CustomDateTime) {
      return microsecondsSinceEpoch > other.microsecondsSinceEpoch;
    }
    throw Exception('Comparison with non-CustomDateTime is not supported');
  }

  @override
  bool isAtSameMomentAs(DateTime other) {
    if (other is CustomDateTime) {
      return microsecondsSinceEpoch == other.microsecondsSinceEpoch;
    }
    throw Exception('Comparison with non-CustomDateTime is not supported');
  }

  @override
  int compareTo(DateTime other) {
    if (other is CustomDateTime) {
      final int a = microsecondsSinceEpoch;
      final int b = other.microsecondsSinceEpoch;
      if (a < b) return -1;
      if (a > b) return 1;
      return 0;
    }
    throw Exception('Comparison with non-CustomDateTime is not supported');
  }

  @override
  String toIso8601String() {
    final date =
        '${instance.year.toString().padLeft(4, '0')}-'
        '${_two(instance.month)}-${_two(instance.day)}'
        'T${_two(instance.hour)}:${_two(instance.minute)}:${_two(instance.second)}'
        '.${_three(instance.millisecond)}${_three(extraMicrosecond)}';
    return isUtc ? '${date}Z' : date;
  }

  @override
  String toString() {
    return '${instance.year.toString().padLeft(4, '0')}-'
        '${_two(instance.month)}-${_two(instance.day)} '
        '${_two(instance.hour)}:${_two(instance.minute)}:${_two(instance.second)}'
        '.${_three(instance.millisecond)}${_three(extraMicrosecond)}d';
  }

  @override
  bool operator ==(Object other) {
    if (other is CustomDateTime) {
      return microsecondsSinceEpoch == other.microsecondsSinceEpoch &&
          isUtc == other.isUtc;
    }
    return false;
  }
}
