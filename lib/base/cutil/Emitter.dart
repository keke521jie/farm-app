import "dart:async";

import "Disposable.dart";

class Emitter<T> extends Disposable {
  final StreamController _streamController;

  Emitter({bool sync = false}) : _streamController = StreamController<T>.broadcast(sync: sync);

  StreamSubscription<T> on(void Function(T value) callback) {
    return (_streamController.stream as Stream<T>).listen(callback);
  }

  void emit(T value) {
    _streamController.add(value);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
