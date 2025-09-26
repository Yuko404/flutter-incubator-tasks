import 'lib/custom_datetime.dart';

void main() {
  CustomDateTime cd = CustomDateTime.now();
  print(cd.microsecond);
  final dt = cd.add(Duration(seconds: 1));
  print(dt);
  cd = cd.add(Duration(microseconds: 37));
  print(cd);
  cd = cd.subtract(Duration(seconds: 10, microseconds: 193));
  print(cd);
  final now = CustomDateTime.now();
  print(now);
  print(now.compareTo(cd));
  print(cd.isAfter(dt));
  print(now.microsecond);
}
