import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_task/data/data_entity.dart';
import 'package:to_do_task/data/repo/repository.dart';
import 'package:to_do_task/data/source/hive_task_source.dart';
import 'package:to_do_task/screens/home/home.dart';

const boxName = 'boxName';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(boxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));

  runApp(
    ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) => 
      Repository<TaskEntity>(HiveTaskDataSource(Hive.box(boxName))),
      child: const MyApp(),
    ),
  );
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
              floatingLabelBehavior: FloatingLabelBehavior.never,
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
      home:  HomeScreen(),
    );
  }
}
