class JokeSettings {
  List<String> categories;
  List<String> blacklistFlags;

  JokeSettings({List<String>? categories, List<String>? blacklistFlags})
      : this.categories = categories ?? [],
        this.blacklistFlags = blacklistFlags ?? [];

  String get categoriesAsString => categories.join(",");
  String get blacklistFlagsAsString => blacklistFlags.isNotEmpty ? "blacklistFlags=${blacklistFlags.join(",")}" : "";

  @override
  String toString() {
    return "Categories: $categoriesAsString, BlacklistFlags: $blacklistFlagsAsString";
  }
}
