import 'package:conduit/conduit.dart';
import 'package:etp_data/models/task.dart';

class TaskType extends ManagedObject<_TaskType> implements _TaskType {}

class _TaskType {
  @primaryKey
  int? id;

  @Column(unique: true, indexed: true)
  String? name;

  ManagedSet<Task>? taskListType;
}
