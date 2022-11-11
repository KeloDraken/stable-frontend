import 'package:flutter/material.dart';

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
    return const Scaffold(
      body: Text("Exploring"),
    );
  }
}
