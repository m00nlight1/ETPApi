import 'package:conduit/conduit.dart';
import 'package:etp_data/models/task.dart';

class Author extends ManagedObject<_Author> implements _Author {}

class _Author {
  @primaryKey
  int? id;
  ManagedSet<Task>? taskList;
}
