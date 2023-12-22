import "dart:async";

import "Disposable.dart";

class Eventbus extends Disposable {
  final StreamController _streamController;

  Eventbus({bool sync = false}) : _streamController = StreamController.broadcast(sync: sync);

  StreamSubscription<T> on<T>(void Function(T value) callback) {
    if (T == dynamic) {
      return (_streamController.stream as Stream<T>).listen(callback);
    } else {
      return _streamController.stream.where((event) => event is T).cast<T>().listen(callback);
    }
  }

  void emit<T>(T value) {
    _streamController.add(value);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
