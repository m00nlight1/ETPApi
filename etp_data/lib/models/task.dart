import 'package:conduit/conduit.dart';
import 'package:etp_data/models/author.dart';

class Task extends ManagedObject<_Task> implements _Task {}

class _Task {
  @primaryKey
  int? id;
  @Column()
  String? title;
  @Column()
  String? content;
  @Column()
  DateTime? startOfWork;
  @Column()
  DateTime? endOfWork;
  @Column(nullable: true)
  String? contractorCompany;
  @Column(nullable: true)
  String? responsibleMaster;
  @Column(nullable: true)
  String? representative;
  @Column(nullable: true)
  String? equipmentLevel;
  @Column(nullable: true)
  String? staffLevel;
  @Column(nullable: true)
  String? resultsOfTheWork;
  @Relate(#taskList, isRequired: true, onDelete: DeleteRule.cascade)
  Author? author;
}
