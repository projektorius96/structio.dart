extension List$Extension on List {
  /// DEV_NOTE # alternatively use [Queue.removeLast]
  List pop() {
    this.removeLast();
    return this;
  }
  /// DEV_NOTE # alternatively use [Queue.removeFirst]
  List shift() {
    this.removeAt(0);
    return this;
  }
  /// DEV_NOTE # alternatively use [Queue.addFirst]
  List unshift(V) {
    this.insert(0, V);
    return this;
  }
  /// DEV_NOTE # alternatively use [Queue.addLast]
  List push(V) {
    this.add(V);
    return this;
  }
}