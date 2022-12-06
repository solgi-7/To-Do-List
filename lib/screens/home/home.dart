import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_task/data/data_entity.dart';
import 'package:to_do_task/data/repo/repository.dart';
import 'package:to_do_task/main.dart';
import 'package:to_do_task/screens/edit/cubit/edit_task_cubit.dart';
import 'package:to_do_task/screens/edit/edit.dart';
import 'package:to_do_task/screens/home/bloc/task_list_bloc.dart';
import 'package:to_do_task/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();
  // final ValueNotifier<String> searchKeyWordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(boxName);
    final themeData = Theme.of(context);
    return Scaffold(
      body: BlocProvider<TaskListBloc>(
        create: (context) =>
            TaskListBloc(context.read<Repository<TaskEntity>>()),
        child: Builder(builder: (context) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                  height: 102,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryVariant,
                  ])),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Do List',
                              style: themeData.textTheme.headline6!.apply(
                                color: themeData.colorScheme.onPrimary,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.share,
                              color: themeData.colorScheme.onPrimary,
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 38,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              color: themeData.colorScheme.onPrimary,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20)
                              ]),
                          child: TextField(
                            onChanged: (value) {
                              context
                                  .read<TaskListBloc>()
                                  .add(TaskListSearch(value));
                            },
                            controller: _searchController,
                            decoration: const InputDecoration(
                              label: Text('Search tasks...'),
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(child: Consumer<Repository<TaskEntity>>(
                  builder: (context, model, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themeData: themeData);
                        } else if (state is TaskListEmpty) {
                          return const EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is TaskListError) {
                          return Center(child: Text(state.errorMsg));
                        } else {
                          throw Exception('state is not valid...');
                        }
                      },
                    );
                  },
                )),
              ],
            ),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(
                    TaskEntity(), context.read<Repository<TaskEntity>>()),
                child: const EditTaskScreen(),
              ),
            ),
          );
        },
        label: const Text('Add New Task'),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.items,
    required this.themeData,
  }) : super(key: key);

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      padding: const EdgeInsets.only(right: 16, top: 16, left: 16, bottom: 100),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: themeData.textTheme.headline6!
                        .apply(fontSizeFactor: 0.8),
                  ),
                  Container(
                    width: 70,
                    height: 3,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  )
                ],
              ),
              MaterialButton(
                onPressed: () {
                  context.read<TaskListBloc>().add(TaskListDeleteAll());
                },
                elevation: 0,
                textColor: secondryTextColor,
                color: const Color(0xffEAEFF5),
                child: Row(
                  children: const [
                    Text(
                      'Delete All',
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          final TaskEntity task = items[index - 1];
          return TaskItem(taskEntity: task);
        }
      },
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.taskEntity,
  }) : super(key: key);
  static const double height = 84;
  static const double borderRaduis = 8;
  final TaskEntity taskEntity;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Color priorityColor;
    switch (widget.taskEntity.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.norma:
        priorityColor = normalPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
    }
    return InkWell(
      onTap: () {
        // setState(() {
        //   widget.taskEntity.isCompleted = !widget.taskEntity.isCompleted;
        // });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider<EditTaskCubit>(
              create: (context) => EditTaskCubit(
                  widget.taskEntity, context.read<Repository<TaskEntity>>()),
              child: const EditTaskScreen(),
            ),
          ),
        );
      },
      onLongPress: () {
        Provider.of<Repository<TaskEntity>>(context, listen: false)
            .delete(widget.taskEntity);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        margin: const EdgeInsets.only(top: 8),
        height: 74,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TaskItem.borderRaduis),
          color: themeData.colorScheme.surface,
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 20,
          //     color: Colors.black.withOpacity(0.2),
          //   )
          // ],
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.taskEntity.isCompleted,
              onTap: () {
                setState(() {
                  widget.taskEntity.isCompleted =
                      !widget.taskEntity.isCompleted;
                });
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.taskEntity.name,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    decoration: widget.taskEntity.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 5,
              height: TaskItem.height,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(TaskItem.borderRaduis),
                  bottomRight: Radius.circular(TaskItem.borderRaduis),
                ),
                color: priorityColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
