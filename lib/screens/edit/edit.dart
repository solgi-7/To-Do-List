import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_task/data/data_entity.dart';
import 'package:to_do_task/data/repo/repository.dart';
import 'package:to_do_task/main.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({Key? key, required this.taskEntity}) : super(key: key);
  final TaskEntity taskEntity;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.taskEntity.name);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    label: 'High',
                    color: primaryColor,
                    isSelected: widget.taskEntity.priority == Priority.high,
                    onTap: () {
                      setState(() {
                        widget.taskEntity.priority = Priority.high;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    label: 'Normal',
                    color: normalPriorityColor,
                    isSelected: widget.taskEntity.priority == Priority.norma,
                    onTap: () {
                      setState(() {
                        widget.taskEntity.priority = Priority.norma;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    label: 'Low',
                    color: lowPriorityColor,
                    isSelected: widget.taskEntity.priority == Priority.low,
                    onTap: () {
                      setState(() {
                        widget.taskEntity.priority = Priority.low;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text('Add a task for today...',
                style: themeData.textTheme.bodyText1!.apply(fontSizeFactor: 1.2)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // final taskEntity = TaskEntity();
          widget.taskEntity.name = _controller.text;
          widget.taskEntity.priority = widget.taskEntity.priority;
          final repository = Provider.of<Repository<TaskEntity>>(context,listen: false);
          repository.createOrUpdate(widget.taskEntity);
          Navigator.pop(context);
        },
        label: Row(
          children: const [
            Text('Save Changes'),
            Icon(
              CupertinoIcons.check_mark,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  const PriorityCheckBox({
    Key? key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    // final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondryTextColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Opacity(
              opacity: 0,
              child: PriorityCheckBoxShap(
                value: isSelected,
                color: color,
              ),
            ),
            Text(label),
            PriorityCheckBoxShap(
              value: isSelected,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBoxShap extends StatelessWidget {
  const PriorityCheckBoxShap(
      {Key? key, required this.color, required this.value})
      : super(key: key);
  final bool value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 12,
              color: themeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
