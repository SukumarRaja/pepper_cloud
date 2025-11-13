import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pepper_cloud/features/task/presentation/bloc/task_bloc.dart';
import 'package:pepper_cloud/features/task/presentation/bloc/task_event.dart';
import 'package:pepper_cloud/features/task/presentation/bloc/task_state.dart';

import '../../../../routes.dart';
import '../../data/models/task_model.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _scrollController = ScrollController();
  final int _perPage = 10;
  int _currentPage = 1;
  bool _hasMore = true;

  bool? _isCompletedFilter;
  DateTime? _dueDateFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialTasks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialTasks() {
    context.read<TaskBloc>().add(
      FetchTask(
        page: _currentPage,
        limit: _perPage,
        isCompleted: _isCompletedFilter,
        dueDate: _dueDateFilter,
        search: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
      ),
    );
  }

  void _loadMoreTasks() {
    if (_hasMore) {
      _currentPage++;
      context.read<TaskBloc>().add(
        FetchTask(page: _currentPage, limit: _perPage),
      );
    }
  }

  void _onScroll() {
    if (_isBottom) _loadMoreTasks();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _navigateToTaskForm([TaskModel? task]) async {
    await Navigator.pushNamed(context, AppRoutes.taskForm, arguments: task);
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isCompletedFilter = null;
                _dueDateFilter = null;
                _searchController.clear();
              });
              _loadInitialTasks();
            },
            child: Text("Reset", style: TextStyle(color: Colors.black)),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshTasks),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is TaskLoaded) {
            setState(() {
              _hasMore =
                  state.pagination!.currentPage < state.pagination!.lastPage ??
                  false;
            });
          }
        },
        builder: (context, state) {
          if (state is TaskLoading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshTasks,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final tasks = state is TaskLoaded ? state.tasks : [];

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Status filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<bool?>(
                          isDense: true,
                          value: _isCompletedFilter,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('All'),
                            ),
                            const DropdownMenuItem(
                              value: true,
                              child: Text('Completed'),
                            ),
                            const DropdownMenuItem(
                              value: false,
                              child: Text('Pending'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _isCompletedFilter = value;
                            });
                            _loadInitialTasks();
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: _dueDateFilter != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(_dueDateFilter!)
                                : '',
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Due Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _dueDateFilter ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                            );
                            if (date != null) {
                              setState(() {
                                _dueDateFilter = date;
                              });
                              _loadInitialTasks();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: tasks.length + (_hasMore ? 1 : 0),
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      if (index >= tasks.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final task = tasks[index];
                      return Dismissible(
                        key: Key(task.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                'Are you sure you want to delete this task?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          // Remove the task from the list immediately
                          final deletedTask = task;
                          setState(() {
                            tasks.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Task "${deletedTask.title}" deleted',
                              ),
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor: Colors.white,
                                onPressed: () {
                                  // Insert the task back at the same position
                                  setState(() {
                                    tasks.insert(index, deletedTask);
                                  });
                                },
                              ),
                            ),
                          );

                          // Delete the task from the server
                          context.read<TaskBloc>().add(DeleteTask(id: task.id));
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (task.description?.isNotEmpty ?? false)
                                  Text(task.description!),
                                if (task.dueDate != null)
                                  Text(
                                    'Due: ${task.dueDate.toString().split(' ')[0]}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                            trailing: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                print("ljlkjkjlj ${value}");
                                context.read<TaskBloc>().add(
                                  ToggleTaskActive(
                                    id: task.id,
                                    isActive: value ?? false,
                                  ),
                                );
                              },
                            ),
                            onTap: () => _navigateToTaskForm(task),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _refreshTasks() async {
    _currentPage = 1;
    _hasMore = true;
    _loadInitialTasks();
  }
}
