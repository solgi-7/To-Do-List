import 'package:hive/hive.dart';
part 'data_entity.g.dart';

@HiveType(typeId: 0)
class TaskEntity extends HiveObject {
  int id = -1;
  @HiveField(0)
  String name = '';
  @HiveField(1)
  bool isCompleted = false;
  @HiveField(2)
  Priority priority = Priority.low;
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  norma,
  @HiveField(2)
  high
}
