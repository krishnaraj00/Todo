import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/task_view.dart';
import '../view_model/widget/task_item.dart';
import 'add_edit_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      final viewModel = Provider.of<TaskViewModel>(context, listen: false);
      switch (_tabController.index) {
        case 0:
          viewModel.setFilter(Filter.all);
          break;
        case 1:
          viewModel.setFilter(Filter.completed);
          break;
        case 2:
          viewModel.setFilter(Filter.pending);
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        title: const Text(
          'My To-Do List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: viewModel.tasks.isEmpty
            ? const Center(
          child: Text(
            "No tasks available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: viewModel.tasks.length,
          itemBuilder: (context, index) => TaskItem(
            task: viewModel.tasks[index],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: const Text('Add Task',style: TextStyle(color: Colors.white),),
        icon: const Icon(Icons.add,color: Colors.white,),
        elevation: 4,
      ),
    );
  }
}
