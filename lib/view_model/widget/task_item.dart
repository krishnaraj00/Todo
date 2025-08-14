import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/model_class.dart';
import '../../view/add_edit_task.dart';
import '../task_view.dart';


class TaskItem extends StatelessWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(task.description),
        ),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            viewModel.updateTask(task.copyWith(isCompleted: value ?? false));
          },
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => viewModel.deleteTask(task.id!),
            ),
          ],
        ),
      ),
    );
  }
}
