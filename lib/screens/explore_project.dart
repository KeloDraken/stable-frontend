import 'package:flutter/material.dart';
import 'package:gorom/components/title_bar.dart';

class ExploreProjectScreen extends StatelessWidget {
  const ExploreProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sága',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "RobotoRegular",
      ),
      home: const ExploreProject(),
    );
  }
}

class ExploreProject extends StatefulWidget {
  const ExploreProject({super.key});

  @override
  State<ExploreProject> createState() => _ExploreProject();
}

class _ExploreProject extends State<ExploreProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[
          TitleBar(),
        ],
      ),
    );
  }
}
