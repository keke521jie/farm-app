import "package:synchronized/synchronized.dart";

typedef LazyloadHandler<T> = Future<T> Function();

class Lazyload<T> {
  final _lock = Lock();
  late LazyloadHandler<T> _handler;
  T? _value;

  Lazyload(LazyloadHandler<T> handler) {
    _handler = handler;
  }

  dirty() {
    _value = null;
  }

  Future<T> renew() async {
    _value = await _handler();
    return _value as T;
  }

  Future<T> get() async {
    if (_value != null) return _value as T;
    return await _lock.synchronized(() async {
      if (_value != null) return _value as T;
      _value = await _handler();
      return _value as T;
    });
  }
}
