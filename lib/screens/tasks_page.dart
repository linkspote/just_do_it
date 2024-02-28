import 'package:flutter/material.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/widgets/task_tile.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  /// Text controller to access whatever the user typed.
  final textController = TextEditingController();

  /// Pre-filled [Task]s list to later use for search and such things.
  final List<Task> allTasks = Task.tasksList();

  /// This boolean keeps track of an ongoing search and is used to change the list label accordingly.
  bool isSearching = false;

  /// This [List] is used to store all found search results as well as to display them.
  List<Task> _foundTasks = [];

  @override
  void initState() {
    _foundTasks = allTasks;
    super.initState();
  }

  /// This method is used to look for [Task]s containing the entered [keyword].
  void _runFilter(String keyword) {
    List<Task> results = [];

    if (keyword.isEmpty) {
      results = allTasks;
      isSearching = false;
    } else {
      // The results are compared in lower case for simplicity.
      results = allTasks
          .where((task) => task.desginator
              .toLowerCase()
              .contains(keyword.trim().toLowerCase()))
          .toList();
      isSearching = true;
    }

    // The setState method must be called in order to update the UI state of stateful Widgets.
    setState(() {
      _foundTasks = results;
    });
  }

  /// This method inverts the current [Checkbox] status of a [TaskTile].
  /// It needs to be improved, because it relies on the index position in any of the [Task] lists
  /// instead of the "unique" identifier.
  void checkboxChanged(bool? value, int index) {
    setState(() {
      allTasks.reversed.toList()[index].completed =
          !allTasks.reversed.toList()[index].completed;
    });
  }

  /// This method is used to show a dialog for creating a new [Task].
  void createTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create a new task"),
        content: TextField(
          autofocus: true,
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                // Adds a new task to the list while providing as little data as possible.
                allTasks.add(
                  Task(
                    id: allTasks.length + 1,
                    desginator: textController.text.trim(),
                  ),
                );
              });
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  /// This method is used to update an existing [Task] and is very similar to [createTask].
  /// The two can surely be generalized to be able to use them for different use cases.
  void updateTask(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update task"),
        content: TextField(
          autofocus: true,
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                allTasks[id].desginator = textController.text.trim();
              });
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  /// This method removes a [Task] and unlike [checkboxChanged] also uses the id of it to do so.
  void deleteTask(int id) {
    setState(() {
      allTasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTask,
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade900,
                    size: 20,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    maxHeight: 20,
                    minWidth: 25,
                  ),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              // The text changes every time a user wants to lookup a task or finishes his search.
              child: Text(
                (isSearching) ? "Results" : "All tasks",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              // The builder creates as many ui elements as necessary for each single [Task].
              child: ListView.builder(
                itemCount: _foundTasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    task: _foundTasks.reversed.toList()[index],
                    onCompletedChanged: (value) =>
                        checkboxChanged(value, index),
                    onDelete: deleteTask,
                    onUpdateDesignator: updateTask,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
