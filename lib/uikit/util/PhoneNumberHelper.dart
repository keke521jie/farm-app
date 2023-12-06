class PhoneNumberHelper {
  ///移除多余符号，+'开头的号码保留'+'号
  static String clean(String phone) {
    var num = phone.replaceAllMapped(RegExp(r"[^0-9]"), (m) => "");
    if (phone.startsWith("+")) {
      return "+$num";
    } else {
      return num;
    }
  }

  /// 按照美国电话号码格式化，333-444-5555
  static String formatUS(String phone) {
    if (phone.length <= 3) return phone;
    if (phone.length <= 6) {
      return "${phone.substring(0, 3)}-${phone.substring(3, phone.length)}";
    }
    return "${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6, phone.length)}";
  }
}
