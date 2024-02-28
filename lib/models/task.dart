/// Represents the data model for [Task] object.
class Task {
  /// The "unique" identifier of a [Task]. It will be initialized later on.
  late int id;

  /// The "name" of a [Task]. It will be initialized later on by user input and is not optional.
  late String desginator;

  /// [completed] is used to keep track of task status, defaults to false and is not optional.
  bool completed = false;

  /// Not implemented (therefore optional), but should be used to show tasks in a today and a upcoming section.
  DateTime? dueDate;

  /// Constructs a simple [Task] object. Unnecessary data can be left out.
  Task({
    required this.id,
    required this.desginator,
    this.completed = false,
    this.dueDate,
  });

  /// As multiple problems occured when relying on packages like Isar or Hive the app doesn't support
  /// persistent storage at this moment. Sadly there are not a lot of packages which can be used for
  /// multiplatform development without a hassle.
  static List<Task> tasksList() {
    return [
      Task(id: 1, desginator: "Buy groceries", completed: true),
      Task(id: 2, desginator: "Check emails", dueDate: DateTime.now()),
      Task(id: 3, desginator: "Meeting with boss"),
      Task(id: 4, desginator: "Cook dinner"),
      Task(
          id: 5,
          desginator: "Enter flow state",
          dueDate: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 1)),
    ];
  }
}
