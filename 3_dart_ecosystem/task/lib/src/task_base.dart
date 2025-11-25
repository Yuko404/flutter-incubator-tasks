/// Калькулятор для простых вычислительных операций.
///
/// Поддерживает функции сложения, вычитания, умножения и деления.
/// Все операции выполняются с числами типа [double]
///
/// Пример использования:
/// ```dart
/// final calc = Calculator();
/// print (calc.sum(5,6)); // 11.0
/// ```
class Calculator {
  const Calculator();

  /// Вычисляет сумму двух чисел [a] и [b].
  double sum(double a, double b) {
    return a + b;
  }

  /// Вычисляет разницу двух чисел [a] и [b].
  double subtract(double a, double b) {
    return a - b;
  }

  /// Вычисляет произведения двух чисел [a] и [b].
  double multiply(double a, double b) {
    return a * b;
  }

  /// Вычисляет частное от деление [a] на [b].
  ///
  /// Выбрасывает [DivisionByZeroException], если [b] = 0.
  double divide(double a, double b) {
    if (b == 0) {
      throw DivisionByZeroException();
    }
    return a / b;
  }
}

/// Исключение для деления на ноль.
///
/// Выбрасывает сообщение об невозможности деления на 0 при вызове.
class DivisionByZeroException implements Exception {
  @override
  String toString() {
    return "DivisionByZeroException: Division by zero is not allowed!";
  }
}
