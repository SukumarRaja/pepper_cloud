import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pepper_cloud/features/task/data/models/task_model.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const TaskItem({
    Key? key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onComplete?.call(),
        ),
        title: Text(
          task.title,
          style: textTheme.titleMedium?.copyWith(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? theme.disabledColor : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted ? theme.disabledColor : null,
                  ),
                ),
              ),
            if (task.dueDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: _getDueDateColor(context, task.dueDate!),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, y • hh:mm a').format(task.dueDate!),
                      style: textTheme.bodySmall?.copyWith(
                        color: _getDueDateColor(context, task.dueDate!),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Color _getDueDateColor(BuildContext context, DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (task.isCompleted) {
      return Theme.of(context).disabledColor;
    } else if (difference.isNegative) {
      return Colors.red;
    } else if (difference.inHours < 24) {
      return Colors.orange;
    }
    
    return Theme.of(context).hintColor;
  }
}
