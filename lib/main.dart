import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:gorom/screens/create_project.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sága',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "RobotoRegular"),
      home: CreateProject(
        title: 'Sága',
      ),
    );
  }
}
