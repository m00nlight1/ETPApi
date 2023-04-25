import 'package:conduit/conduit.dart';
import 'package:etp_data/models/task.dart';

class Industry extends ManagedObject<_Industry> implements _Industry {}

class _Industry {
  @primaryKey
  int? id;

  @Column(unique: true, indexed: true)
  String? name;

  ManagedSet<Task>? taskDeffIndustry;
}
