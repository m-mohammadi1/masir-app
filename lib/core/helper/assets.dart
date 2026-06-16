class Assets {
  /// PNG
  static String _png(String src) => 'assets/png/$src.png';

  static String get light => _png("light");
  static String get logo => _png("logo");
  static String get banner => _png("banner");
  static String get telegram => _png("telegram");
  static String get whatsapp => _png("whatsapp");
  static String get phone => _png("phone");

  /// SVG
  static String _svg(String src) => 'assets/svg/$src.svg';

  static String get homeSelected => _svg("home_selected");
  static String get home => _svg("home");
  static String get add => _svg("add");
  static String get mediumEdit => _svg("medium_edit");
  static String get aboutUs => _svg("about_us");
  static String get exit => _svg("exit");
  static String get profile => _svg("profile");
  static String get profileSelected => _svg("profile_selected");
  static String get more => _svg("more");
  static String get delete => _svg("delete");
  static String get arrowBack => _svg("arrow_back");
  static String get edit => _svg("edit");

  Assets._();
}
