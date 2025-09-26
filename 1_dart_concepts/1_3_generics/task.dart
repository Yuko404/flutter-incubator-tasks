// Maybe, will be better to use getter instead of method, because Efective Dart
// guide recommends using getters for such cases (and for me it looks more
// beautiful))
// But, in the task description, it is said "method", so I used method.

/// A method, returning the maximum element from a `Comparable` list.
extension maxElement<T extends Comparable<T>> on List<T> {
  T findMaxElement() {
    if (isEmpty) {
      throw EmptyListException();
    }
    T maxElement = first;
    for (int index = 1; index < length; index++) {
      if (this[index].compareTo(maxElement) > 0) {
        maxElement = this[index];
      }
    }
    return maxElement;
  }
}

class EmptyListException implements Exception {}

// Test cases
void main() {
  final intList = [-10, 4, -1, 31, 2, 5, 24, 10];
  final stringList = ['apple', 'banana', 'pear', 'grape', 'zebra', 'hhh'];
  final doubleList = [1.5, 2.3, 0.7, 4.1, -0.4, 0.983, -12.4];
  final emptyList = <int>[];
  final singleElementList = [10];

  print('Max for int: ${intList.findMaxElement()}');
  print('Max for string: ${stringList.findMaxElement()}');
  print('Max for double: ${doubleList.findMaxElement()}');
  print('Max for singleElementInt: ${singleElementList.findMaxElement()}');
  try {
    print('Max for emptyList: ${emptyList.findMaxElement()}');
  } on EmptyListException {
    print('Empty list has no maximum element');
  }
}
