import 'package:task/task.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late Calculator calc;

    setUp(() {
      calc = const Calculator();
    });

    test('Сложение работает корректно с большими числами', () {
      expect(calc.sum(2379529882, 2385792875298), 2388172405180);
    });
    test('Перемножение орицательных чисел даёт положительное число', () {
      expect(calc.multiply(-346, -1), 346);
    });
    test('Деление на ноль выбрасывает исключение', () {
      expect(() => calc.divide(5, 0), throwsA(isA<DivisionByZeroException>()));
    });
    test(
      'Вычистание отрицательного числа аналогично сложению с значением по модулю',
      () {
        expect(calc.subtract(45, -13), calc.sum(45, 13));
      },
    );
  });
}
