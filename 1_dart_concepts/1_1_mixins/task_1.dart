import 'package:intl/intl.dart';

// Решение без использования каких-либо библиотек
extension WithoutLibs on DateTime {
  String toYMDhmsFormat() {
    final List<int> components = [year, month, day, hour, minute, second];
    final List<String> formatted = List.generate(
      components.length,
      (int index) =>
          components[index].toString().padLeft(((index == 0) ? 4 : 2), '0'),
    );
    return '${formatted[0]}.${formatted[1]}.${formatted[2]} ${formatted[3]}:${formatted[4]}:${formatted[5]}';
  }
}

// Решение с использованием библиотеки [intl]
extension WithLibs on DateTime {
  String toYMDhmsFormat() {
    final DateFormat formatYMDhms = DateFormat("yyyy.MM.dd HH:mm:ss");
    return formatYMDhms.format(this);
  }
}

void main() {
  final now = DateTime.now();
  print(WithoutLibs(now).toYMDhmsFormat());
  print(WithLibs(now).toYMDhmsFormat());
}
