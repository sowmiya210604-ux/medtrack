// Stub implementation of File and Platform for web platform
class File {
  final String path;
  File(this.path);

  bool existsSync() => false;
  Future<void> writeAsString(String contents) async {}
}

class Platform {
  static bool get isAndroid => false;
  static bool get isIOS => false;
  static bool get isWindows => false;
  static bool get isMacOS => false;
  static bool get isLinux => false;
}
