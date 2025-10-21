// Write a simple in-memory key-value database with simulated delays
// (adding and getting values should be asynchronous). It should expose a
// [`Stream`] of its changes, and use [generics][1] for storing data.

import 'dart:async';

enum ChangeType { add, remove, update }

class Change<K extends Object, V> {
  ChangeType changeType;
  K keyOfChange;
  V? valueOfChange;

  Change(this.changeType, this.keyOfChange, this.valueOfChange);

  String toString() {
    return '${changeType.name[0].toUpperCase()}${changeType.name.substring(1)} $valueOfChange by $keyOfChange';
  }
}

class Database<K extends Object, V extends Object> {
  final Map<K, V> _mapOfValues = {};
  final _changesController = StreamController<Change<K, V>>.broadcast();

  Stream<Change<K, V>> get changes => _changesController.stream;

  Future<void> addValue(K key, V value) async {
    await Future.delayed(Duration(milliseconds: 500));
    final bool keyExisted = _mapOfValues.containsKey(key);

    _mapOfValues[key] = value;

    final changeType = keyExisted ? ChangeType.update : ChangeType.add;
    final change = Change(changeType, key, value);
    _changesController.add(change);
  }

  Future<V?> remove(K key) async {
    await Future.delayed(Duration(milliseconds: 600));
    final V? value = _mapOfValues.remove(key);
    final change = Change(ChangeType.remove, key, value);
    _changesController.add(change);
    return value;
  }

  Future<V?> getValue(K key) async {
    await Future.delayed(Duration(milliseconds: 300));
    final V? value = _mapOfValues[key];
    return value;
  }

  Future<Iterable<V>> getValues() async {
    await Future.delayed(Duration(milliseconds: 200));
    return _mapOfValues.values.toList();
  }

  Future<Iterable<K>> getKeys() async {
    await Future.delayed(Duration(milliseconds: 200));
    return _mapOfValues.keys.toList();
  }

  Future<bool> hasValueOnKey(K key) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _mapOfValues.containsKey(key);
  }

  Future<void> updateValue(K key, V value) async {
    await Future.delayed(Duration(milliseconds: 300));
    if (_mapOfValues.containsKey(key)) {
      _mapOfValues[key] = value;
      final change = Change(ChangeType.update, key, value);
      _changesController.add(change);
    } else {
      throw KeyNotFoundException();
    }
  }

  void dispose() {
    _changesController.close();
  }
}

class KeyNotFoundException implements Exception {}

Future<void> main() async {
  Database<int, String> dataBaseIntStr = Database();

  dataBaseIntStr.changes.listen((Change<int, String> change) {
    print('Произошло изменение: $change');
  });

  await dataBaseIntStr.addValue(1, '4');
  await dataBaseIntStr.addValue(6, 'Hello!');
  await dataBaseIntStr.addValue(0, 'Dart');
  await dataBaseIntStr.getValue(0);
  await dataBaseIntStr.updateValue(6, 'Hello, Dart');
  await dataBaseIntStr.remove(1);
  await dataBaseIntStr.addValue(0, 'Flutter');
  print(await dataBaseIntStr.getKeys());
  print(await dataBaseIntStr.getValues());
  print(await dataBaseIntStr.hasValueOnKey(7));
  dataBaseIntStr.dispose();
}
