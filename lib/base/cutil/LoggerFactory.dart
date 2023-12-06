import "package:logger/logger.dart" as logg;

class LoggerFactory {
  static bool _init = false;

  static void init() {
    logg.Logger.level = logg.Level.info;
  }

  static Logger getLogger({List<String> tag = const []}) {
    if (!_init) {
      _init = true;
      init();
    }
    var logger = logg.Logger(
      printer: LoggerPrettyPrinter(tag: tag),
    );
    return Logger(logger);
  }
}

class Logger {
  logg.Logger logger;

  Logger(this.logger);

  void v(dynamic message, [dynamic error, StackTrace? stackTrace, List<String> tag = const []]) {
    logger.v(message, error, stackTrace);
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace, List<String> tag = const []]) {
    logger.d(message, error, stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace, List<String> tag = const []]) {
    logger.i(message, error, stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace, List<String> tag = const []]) {
    logger.w(message, error, stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace, List<String> tag = const []]) {
    logger.e(message, error, stackTrace);
  }
}

class LoggerPrettyPrinter extends logg.PrettyPrinter {
  List<String> tag;

  LoggerPrettyPrinter({this.tag = const []})
      : super(
          stackTraceBeginIndex: 0,
          methodCount: 3,
          errorMethodCount: 1,
          lineLength: 120,
          colors: false,
          printEmojis: true,
          printTime: true,
          excludeBox: const {},
          noBoxingByDefault: true,
        );

  @override
  List<String> log(logg.LogEvent event) {
    var list = super.log(event);
    list.removeAt(0);
    list.removeAt(0);
    var source = list.removeAt(0).replaceRange(0, 5, "");
    var time = list.removeAt(0);
    var message = list.removeAt(0);
    var icon = message.substring(0, 3);
    message = message.replaceRange(0, 3, "");

    var tagStr = "";
    if (tag.isNotEmpty) {
      tagStr = "${tag.join(",")} ";
    }

    var out = "$icon$time $source $tagStr$message";
    return [out];
  }
}
