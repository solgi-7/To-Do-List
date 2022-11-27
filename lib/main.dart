import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_task/data_entity.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(boxName);
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
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
                      child: const TextField(
                        decoration: InputDecoration(
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
                builder: (context, boxValue, child) => ListView.builder(
                    itemCount: boxValue.values.length + 1,
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
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                )
                              ],
                            ),
                            MaterialButton(
                              onPressed: () {},
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
                        final TaskEntity taskEntity =
                            box.values.toList()[index - 1];
                        return SizedBox(
                          child: Text(
                            taskEntity.name,
                            style: const TextStyle(fontSize: 24),
                          ),
                        );
                      }
                      final TaskEntity taskEntity = box.values.toList()[index];
                      return SizedBox(
                        child: Text(
                          taskEntity.name,
                          style: const TextStyle(fontSize: 24),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => EditTaskScreen(),
            ),
          );
        },
        label: const Text('Add New Task'),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  EditTaskScreen({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              label: Text('Add a task for today...'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final taskEntity = TaskEntity();
          taskEntity.name = _controller.text;
          taskEntity.priority = Priority.low;
          if (taskEntity.isInBox) {
            taskEntity.save();
          } else {
            final Box<TaskEntity> box = Hive.box(boxName);
            box.add(taskEntity);
          }
          Navigator.pop(context);
        },
        label: const Text('Save Changes'),
      ),
    );
  }
}
