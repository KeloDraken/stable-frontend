import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gorom/components/title_bar.dart';
import 'package:window_manager/window_manager.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key, required this.title});

  final String title;

  @override
  State<CreateProject> createState() => _CreateProject();
}

class _CreateProject extends State<CreateProject> with WindowListener {
  dynamic _getProjectDirectory() async {
    String? projectDirectory = await FilePicker.platform.getDirectoryPath();

    if (projectDirectory == null) return null;

    if (kDebugMode) print(projectDirectory);

    return projectDirectory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            TitleBar(title: widget.title),
            ElevatedButton(
              onPressed: () {
                _getProjectDirectory();
              },
              child: const Text("Open project"),
            )
          ],
        ),
      ),
    );
  }
}
