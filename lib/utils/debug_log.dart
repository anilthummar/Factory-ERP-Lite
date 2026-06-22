import 'exports.dart';

/// A utility class for logging debug information.
class DebugLog {
  /// Creates a new instance of [DebugLog].
  static DebugLog instance = getIt<DebugLog>();
  Logger? _logger;

  /// Saves log to local storage for web.
  /// This function creates local storage for web app to store app log.
  /// It will only be able to show when app is running state.
  Future<void> _saveLogToLocalStorage(String log) async {
    String currentLogs = window.localStorage['logs'] ?? '';
    window.localStorage['logs'] = '$currentLogs$log\n';
  }

  /// Generates a file for log records.
  Future<File> _getDirectoryForLogRecord() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/logger.txt');
    return file;
  }

  /// Writes log in file.
  Future<List<LogOutput>> _writeLogInFile() async {
    List<LogOutput> multiOutput = <LogOutput>[];
    File file = await _getDirectoryForLogRecord();
    FileOutput fileOutPut = FileOutput(file: file);
    ConsoleOutput consoleOutput = ConsoleOutput();
    multiOutput = <LogOutput>[fileOutPut, consoleOutput];
    return multiOutput;
  }

  /// Initializes the logger.
  Future<void> init() async {
    _logger ??= Logger(
      filter: DevelopmentFilter(),
      printer: PrettyPrinter(
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
      output: !kIsWeb
          ? MultiOutput(await _writeLogInFile())
          : MultiOutput(<LogOutput?>[ConsoleOutput(), WebOutput()]),
    );
  }

  /// Logs a debug message.
  void d(dynamic message) {
    if (kDebugMode) {
      _logger?.d(message);
    }
  }

  /// Logs a trace message.
  void t(dynamic message) {
    if (kDebugMode) {
      _logger?.t(message);
    }
  }

  /// Logs an error message.
  void e(dynamic message, [dynamic errors]) {
    if (kDebugMode) {
      _logger?.e(message, error: errors);
    }
  }

  /// Logs a warning message.
  void w(dynamic message) {
    if (kDebugMode) {
      _logger?.w(message);
    }
  }

  /// Logs an info message.
  void i(dynamic message) {
    if (kDebugMode) {
      _logger?.i(message);
    }
  }
}

/// A custom output class for logging to web local storage.
/// Created override method to write log in local storage.
class WebOutput extends LogOutput {
  @override
  Future<void> output(OutputEvent event) async {
    String logMessage =
        '============================================================================='
        '\n${event.level.name}: ${event.origin.message}'
        '\n=============================================================================';
    await DebugLog.instance._saveLogToLocalStorage(logMessage);
  }
}
