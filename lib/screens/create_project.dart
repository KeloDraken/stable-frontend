import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key, required this.title});

  final String title;

  @override
  State<CreateProject> createState() => _CreateProject();
}

class _CreateProject extends State<CreateProject> {
  dynamic _getProjectDirectory() async {
    String? projectDirectory = await FilePicker.platform.getDirectoryPath();

    if (projectDirectory == null) return null;

    if (kDebugMode) print(projectDirectory);

    return projectDirectory;
  }

  Widget _renderLogo() {
    return Row(
      children: <Widget>[
        const Text(
          "kelodraken",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            fontFamily: "Lobster",
          ),
        ),
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w600,
            fontFamily: "RobotoThin",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Center(
          child: Column(
            children: <Widget>[
              _renderLogo(),
              ElevatedButton(
                onPressed: () {
                  _getProjectDirectory();
                },
                child: const Text("Open project"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
