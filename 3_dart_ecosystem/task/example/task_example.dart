import 'package:task/task.dart';

void main() {
  final calc = Calculator();
  print('sum: ${calc.sum(1, 3)}, subtract: ${calc.subtract(4, 10)}');
  assert(calc.multiply(5, 3) == 15);
}
