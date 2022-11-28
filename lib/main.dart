import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_task/data_entity.dart';
import 'package:to_do_task/edit.dart';

const boxName = 'boxName';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(boxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));

  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
const secondryTextColor = Color(0xffAFBED0);
const Color highPriorityColor = primaryColor;
const Color normalPriorityColor = Color(0xffF09819);
const Color lowPriorityColor = Color(0xff3BE1F1);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          // textTheme: GoogleFonts.poppinsTextTheme(
          //   const TextTheme(
          //     headline6: TextStyle(fontWeight: FontWeight.bold)
          //   )
          // ),
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: secondryTextColor),
              border: InputBorder.none),
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            primaryVariant: primaryVariantColor,
            background: Color(0xffF3F5F8),
            onSurface: primaryTextColor,
            onPrimary: Colors.white,
            onBackground: primaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white,
          )),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(boxName);
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
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
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
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
            Expanded(
              child: ValueListenableBuilder<Box<TaskEntity>>(
                  valueListenable: box.listenable(),
                  builder: (context, boxValue, child) {
                    final items;
                    if (_searchController.text.isEmpty) {
                      items = box.values.toList();
                    } else {
                      items = box.values.where(
                        (element) =>
                            element.name.contains(_searchController.text),
                      ).toList();
                    }
                    if (items.isNotEmpty) {
                      return ListView.builder(
                        itemCount: items.length + 1,
                        padding: const EdgeInsets.only(
                            right: 16, top: 16, left: 16, bottom: 100),
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
                                        borderRadius:
                                            BorderRadius.circular(1.5),
                                      ),
                                    )
                                  ],
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    box.clear();
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
                            final TaskEntity task =
                                items[index - 1];
                            return TaskItem(taskEntity: task);
                          }
                        },
                      );
                    } else {
                      return const EmptyState();
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => EditTaskScreen(
                taskEntity: TaskEntity(),
              ),
            ),
          );
        },
        label: const Text('Add New Task'),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/img/empty_state.svg',
          width: 120,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text('Your Task List is Empty'),
      ],
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
            builder: (BuildContext context) =>
                EditTaskScreen(taskEntity: widget.taskEntity),
          ),
        );
      },
      onLongPress: () {
        widget.taskEntity.delete();
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

class MyCheckBox extends StatelessWidget {
  const MyCheckBox({Key? key, required this.onTap, required this.value})
      : super(key: key);
  final bool value;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              !value ? Border.all(color: secondryTextColor, width: 2) : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                size: 16,
                color: themeData.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}
