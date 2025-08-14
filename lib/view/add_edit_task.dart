import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model_class.dart';
import '../view_model/task_view.dart';


class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newTask = Task(
                        id: widget.task?.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        isCompleted: widget.task?.isCompleted ?? false,
                      );
                      if (widget.task == null) {
                        await viewModel.addTask(newTask);
                      } else {
                        await viewModel.updateTask(newTask);
                      }
                      Navigator.pop(context);
                    }
                  },
                  label: const Text('Save Task'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
