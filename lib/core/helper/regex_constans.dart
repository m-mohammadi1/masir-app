class RegexConstants {
  static RegExp emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  static bool checkEmail(String email) => emailRegex.hasMatch(email);

  static RegExp passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$\/])[A-Za-z\d@#$\/]{8,}$");

  static bool checkPassword(String pass) => passwordRegex.hasMatch(pass);

  static RegExp shebaRegex = RegExp(r'^\d{24}$');

  static bool checkShebaNumber(String n) => shebaRegex.hasMatch(n);

  static RegExp bankRegex = RegExp(r'^\d{8}$');

  static bool checkBankNumber(String n) => bankRegex.hasMatch(n);

  static RegExp cardRegex = RegExp(r'^\d{16}$');

  static bool checkCardNumber(String n) => cardRegex.hasMatch(n);
}
