import 'package:conduit/conduit.dart';
import 'package:etp_data/models/task.dart';

class Status extends ManagedObject<_Status> implements _Status {}

class _Status {
  @primaryKey
  int? id;

  @Column(unique: true, indexed: true)
  String? name;

  ManagedSet<Task>? listTask;
}
