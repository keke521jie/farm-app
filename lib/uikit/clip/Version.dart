class Version implements Comparable<Version> {
  static final RegExp _versionRegex = RegExp(r"^([\d.]+)(-([0-9A-Za-z\-.]+))?(\+([0-9A-Za-z\-.]+))?$");

  final int major;

  final int minor;

  final int patch;

  Version(this.major, this.minor, this.patch) {
    if (major < 0 || minor < 0 || patch < 0) {
      throw ArgumentError("Version numbers must be greater than 0");
    }
  }

  @override
  int get hashCode => toString().hashCode;

  bool operator <(dynamic o) => o is Version && _compare(this, o) < 0;

  bool operator <=(dynamic o) => o is Version && _compare(this, o) <= 0;

  @override
  bool operator ==(dynamic o) => o is Version && _compare(this, o) == 0;

  bool operator >(dynamic o) => o is Version && _compare(this, o) > 0;

  bool operator >=(dynamic o) => o is Version && _compare(this, o) >= 0;

  @override
  int compareTo(Version? other) {
    if (other == null) {
      throw ArgumentError.notNull("other");
    }

    return _compare(this, other);
  }

  @override
  String toString() {
    final StringBuffer output = StringBuffer("$major.$minor.$patch");
    return output.toString();
  }

  static Version parse(String versionString) {
    if (versionString.trim().isEmpty) {
      throw const FormatException("Cannot parse empty string into version");
    }
    if (!_versionRegex.hasMatch(versionString)) {
      throw const FormatException("Not a properly formatted version string");
    }
    final Match m = _versionRegex.firstMatch(versionString)!;
    final String version = m.group(1)!;

    int? major, minor, patch;
    final List<String> parts = version.split(".");
    major = int.parse(parts[0]);
    if (parts.length > 1) {
      minor = int.parse(parts[1]);
      if (parts.length > 2) {
        patch = int.parse(parts[2]);
      }
    }
    return Version(major, minor ?? 0, patch ?? 0);
  }

  static int _compare(Version? a, Version? b) {
    if (a == null) {
      throw ArgumentError.notNull("a");
    }

    if (b == null) {
      throw ArgumentError.notNull("b");
    }

    if (a.major > b.major) return 1;
    if (a.major < b.major) return -1;

    if (a.minor > b.minor) return 1;
    if (a.minor < b.minor) return -1;

    if (a.patch > b.patch) return 1;
    if (a.patch < b.patch) return -1;
    return 0;
  }
}
