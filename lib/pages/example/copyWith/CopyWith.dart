import "package:copy_with_extension/copy_with_extension.dart";

part "CopyWith.g.dart";

@CopyWith(copyWithNull: true)
class SimpleObjectOldStyle {
  const SimpleObjectOldStyle({required this.id, required this.intValue});

  final String id;
  final int intValue;
}

class CopyWithExample {
  test() {
    var value = const SimpleObjectOldStyle(id: "size", intValue: 20);
    value.copyWith(intValue: 10);
  }
}
