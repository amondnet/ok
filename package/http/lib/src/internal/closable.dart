abstract class Closable {
  Future<void> close();

  bool get isClosed;
}
