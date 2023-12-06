import "dart:async";

/*
class UnauthorizedMsg {
  UnauthorizedMsg(int statusCode);
}

_handleUnauthorizedMsg(msg) {
  logger.i("StartedHomeMsg");
}

eventbus.on<UnauthorizedMsg>().listen(_handleUnauthorizedMsg);

eventbus.emit(UnauthorizedMsg(statusCode));

 */
class Eventbus {
  final StreamController _streamController;

  Eventbus({bool sync = false}) : _streamController = StreamController.broadcast(sync: sync);

  Stream<T> on<T>() {
    if (T == dynamic) {
      return _streamController.stream as Stream<T>;
    } else {
      return _streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void emit(event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}
