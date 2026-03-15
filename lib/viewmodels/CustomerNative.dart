import 'package:isar/isar.dart';

export 'CustomerNative.dart';
part 'CustomerNative.g.dart';

@collection
class Customer {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  @Index(type: IndexType.value)
  late String phone;

  late String tag;

  late DateTime createdAt;

  late int rating;

  String? note;
}
