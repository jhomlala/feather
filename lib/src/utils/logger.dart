class Logger {
  static log(String tag, String content) {
    print("[" + DateTime.now().toString() + "][" + tag + "] " + content);
  }
}
