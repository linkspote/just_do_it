import 'package:flutter/material.dart';
import 'package:just_do_it/models/task.dart';

class TaskTile extends StatelessWidget {
  /// This [Task] is used to display information like a [Task]s designator, it's id and it's completed state.
  final Task task;

  /// This function acts more like a passthrough for a change listener event for the [Checkbox].
  final Function(bool?)? onCompletedChanged;

  /// This function is used to enable the [Task] deletion to work as expected.
  final Function(int) onDelete;

  /// This function is used to enable changing the designator of a [Task].
  final Function(int) onUpdateDesignator;

  /// Constructs the [TaskTile] objects for the [Task] list.
  const TaskTile({
    super.key,
    required this.task,
    required this.onCompletedChanged,
    required this.onDelete,
    required this.onUpdateDesignator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ListTile(
        onTap: () => onUpdateDesignator(task.id - 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Checkbox(
          value: task.completed,
          onChanged: onCompletedChanged,
          activeColor: Colors.amber.shade500,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.desginator,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade900,
                decoration: task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            Text(
              "#${task.id.toString()}", // String interpolation shall be more efficient than concatenation.
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red.shade300,
          ),
          onPressed: () => onDelete(task.id),
          tooltip: "Delete task",
        ),
      ),
    );
  }
}
