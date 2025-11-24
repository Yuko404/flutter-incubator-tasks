import 'package:dart_basics/task.dart' hide DurationStringConverter;
import 'package:task2/task2.dart';

part 'task2.my.dart';

@JsonSerializableForTask()
class Person {
  const Person({required this.name, required this.birthday});
  final String name;
  final DateTime birthday;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializableForTask()
class DartTask {
  DartTask({
    required this.line,
    required this.age,
    required this.duration,
    required this.justALine,
    required this.timeFromBegin,
  });
  final String line;
  final int age;
  String? justALine;
  DateTime timeFromBegin;
  Duration duration;

  factory DartTask.fromJson(Map<String, dynamic> json) =>
      _$DartTaskFromJson(json);
  Map<String, dynamic> toJson() => _$DartTaskToJson(this);
}
