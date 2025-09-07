import 'dart:async';
import 'dart:math';

class Server {
  /// [StreamController] simulating an ongoing websocket endpoint.
  StreamController<int>? _controller;

  /// [Timer] periodically adding data to the [_controller].
  Timer? _timer;

  /// Initializes this [Server].
  Future<void> init() async {
    final Random random = Random();

    while (true) {
      _controller = StreamController();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _controller?.add(timer.tick);
      });

      // Oops, a crash happened...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );

      // Kill the [StreamController], simulating a network loss.
      _controller?.addError(DisconnectedException());
      _controller?.close();
      _controller = null;

      _timer?.cancel();
      _timer = null;

      // Waiting for server to recover...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );
    }
  }

  /// Returns a [Stream] of data, if this [Server] is up and reachable, or
  /// throws [DisconnectedException] otherwise.
  Future<Stream<int>> connect() async {
    if (_controller != null) {
      return _controller!.stream;
    } else {
      throw DisconnectedException();
    }
  }
}

class DisconnectedException implements Exception {}

class Client {
  Future<void> connect(Server server) async {
    const int maxDelayInMilliseconds = 4000;
    const int initialDelayInMilliseconds = 500;
    int delayInMilliseconds = initialDelayInMilliseconds;
    while (true) {
      try {
        var stream = await server.connect();
        print('Подключение установлено. Получаем данные:');
        delayInMilliseconds = initialDelayInMilliseconds;
        await for (var data in stream) {
          print(data);
        }
      } on DisconnectedException {
        if (delayInMilliseconds < maxDelayInMilliseconds) {
          delayInMilliseconds *= 2;
        }
        print(
          'Ошибка подключения, переподключение через ${delayInMilliseconds / 1000} сек.',
        );
        await Future.delayed(Duration(milliseconds: delayInMilliseconds));
      }
    }
  }
}

Future<void> main() async {
  Client()..connect(Server()..init());
}
