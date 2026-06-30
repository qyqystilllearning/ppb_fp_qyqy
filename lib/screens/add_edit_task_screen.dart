import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_task.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TodoTask? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descController;
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  DateTime? _reminderDate;
  TimeOfDay? _reminderTime;
  
  String? _selectedCategory;

  final List<String> _categories = ['Work', 'Personal', 'School', 'Health', 'Finance'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _selectedCategory = widget.task?.category;
    
    if (widget.task?.dueDate != null) {
      _selectedDate = widget.task!.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.dueDate!);
    }
    
    if (widget.task?.reminderDate != null) {
      _reminderDate = widget.task!.reminderDate;
      _reminderTime = TimeOfDay.fromDateTime(widget.task!.reminderDate!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _pickReminderDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _reminderDate = date);
    }
  }

  Future<void> _pickReminderTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _reminderTime = time);
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      DateTime? finalDueDate;
      if (_selectedDate != null) {
        finalDueDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime?.hour ?? 0,
          _selectedTime?.minute ?? 0,
        );
      }

      DateTime? finalReminderDate;
      if (_reminderDate != null) {
        finalReminderDate = DateTime(
          _reminderDate!.year,
          _reminderDate!.month,
          _reminderDate!.day,
          _reminderTime?.hour ?? 0,
          _reminderTime?.minute ?? 0,
        );
      }

      final task = widget.task ?? TodoTask();
      task.title = _titleController.text.trim();
      task.description = _descController.text.trim();
      task.category = _selectedCategory;
      task.dueDate = finalDueDate;
      task.reminderDate = finalReminderDate;

      DatabaseService.saveTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create New Task'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                Text('Task Title', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (val) => val == null || val.isEmpty ? 'Title cannot be empty' : null,
                  decoration: InputDecoration(
                    hintText: 'e.g. Finish final report',
                    filled: true,
                    fillColor: Theme.of(context).cardTheme.color,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),

                // Category Selector
                Text('Category', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = selected ? cat : null);
                      },
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Theme.of(context).cardTheme.color,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Date & Time
                Text('Deadline', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                              const SizedBox(width: 12),
                              Text(
                                _selectedDate == null ? 'Select Date' : DateFormat('MMM d, yyyy').format(_selectedDate!),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _pickTime,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, color: AppTheme.primaryColor),
                              const SizedBox(width: 12),
                              Text(
                                _selectedTime == null ? 'Select Time' : _selectedTime!.format(context),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Reminder Date & Time
                Text('Set Custom Reminder (Optional)', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickReminderDate,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.notifications_active, color: AppTheme.accentColor),
                              const SizedBox(width: 12),
                              Text(
                                _reminderDate == null ? 'Reminder Date' : DateFormat('MMM d, yyyy').format(_reminderDate!),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _pickReminderTime,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.alarm, color: AppTheme.accentColor),
                              const SizedBox(width: 12),
                              Text(
                                _reminderTime == null ? 'Reminder Time' : _reminderTime!.format(context),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description Field
                Text('Description (Optional)', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Add some details...',
                    filled: true,
                    fillColor: Theme.of(context).cardTheme.color,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        isEditing ? 'Update Task' : 'Create Task',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
