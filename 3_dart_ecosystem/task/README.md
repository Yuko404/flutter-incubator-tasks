<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

# task

Простой калькулятор для базовых операций.

## Возможности

- Операции деления, умножения, сложения, вычитания
- Поддержка целых чисел
- Защита от деления на 0

## Getting started

```yaml
# Добавьте в список зависимостей
dependencies:
  task: ^1.0.0
```

## Usage

Пример использования:
```dart
import 'package:task/task.dart';

void main() {
  final calc = Calculator();
  print('sum: ${calc.sum(1, 3)}, subtract: ${calc.subtract(4, 10)}');
  assert(calc.multiply(5, 3) == 15);
  calc.divide(5, 0);
}
```

