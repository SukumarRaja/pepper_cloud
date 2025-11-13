import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/task_model.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskFormPage extends StatefulWidget {
  final TaskModel? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  late bool _isCompleted;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _dueDateController = TextEditingController();
    _isCompleted = widget.task?.isCompleted ?? false;

    if (widget.task?.dueDate != null) {
      _dueDate = widget.task!.dueDate is String
          ? DateTime.parse(widget.task!.dueDate as String)
          : widget.task!.dueDate as DateTime;
      _dueDateController.text = DateFormat('yyyy-MM-dd').format(_dueDate!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      final task = TaskModel(
        id: widget.task == null ? 0 : widget.task!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate!,
        isCompleted: _isCompleted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.task == null) {
        // Create new task
        context.read<TaskBloc>().add(
          CreateTask(
            title: task.title,
            description: task.description,
            dueDate: task.dueDate!.toIso8601String(),
            isActive: !task.isCompleted,
          ),
        );
      } else {
        // Update existing task
        context.read<TaskBloc>().add(
          UpdateTask(
            id: task.id,
            title: task.title,
            description: task.description,
            dueDate: task.dueDate!.toIso8601String(),
            isActive: !task.isCompleted,
          ),
        );
      }
    }
  }

  void _deleteTask() {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    context.read<TaskBloc>().add(DeleteTask(id: widget.task!.id!));
  }

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskError) {
          setState(() {
            _isSubmitting = false;
            _errorMessage = state.message;
          });
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is TaskOperationSuccess) {
          Navigator.of(context).pop(true); // Return success
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
          actions: [
            if (widget.task != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _isSubmitting
                    ? null
                    : () => _showDeleteConfirmation(context),
              ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                                setState(() => _errorMessage = null);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                        hintText: 'Enter task title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        hintText: 'Enter task description (optional)',
                      ),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dueDateController,
                      decoration: InputDecoration(
                        labelText: 'Due Date *',
                        border: const OutlineInputBorder(),
                        hintText: 'Select a date',
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: _dueDate != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _isSubmitting
                                    ? null
                                    : () {
                                        setState(() {
                                          _dueDate = null;
                                          _dueDateController.clear();
                                        });
                                      },
                              )
                            : null,
                      ),
                      readOnly: true,
                      onTap: _isSubmitting ? null : () => _selectDate(context),
                      validator: (value) {
                        if (_dueDate == null) {
                          return 'Please select a due date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (widget.task != null) ...[
                      Card(
                        margin: EdgeInsets.zero,
                        child: SwitchListTile(
                          title: const Text(
                            'Mark as completed',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: _isCompleted,
                          onChanged: _isSubmitting
                              ? null
                              : (value) {
                                  setState(() {
                                    _isCompleted = value;
                                  });
                                },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _submitForm();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              widget.task == null
                                  ? 'Create Task'
                                  : 'Update Task',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                    if (widget.task == null) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('CANCEL'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_isSubmitting) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
