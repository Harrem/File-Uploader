extension BetterString on String {
  String shorten(int length) {
    if (this.length > length) {
      return "${substring(0, length)}...";
    }
    return this;
  }
}
