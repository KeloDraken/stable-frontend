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

  List<Widget> _recentProjects() {
    return <Widget>[
      const ListTile(
        leading: Icon(Icons.list),
        trailing: Text(
          "GFG",
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
        title: Text("List item"),
      ),
      const ListTile(
        leading: Icon(Icons.list),
        trailing: Text(
          "GFG",
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
        title: Text("List item"),
      ),
      const ListTile(
        leading: Icon(Icons.list),
        trailing: Text(
          "GFG",
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
        title: Text("List item"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TitleBar(title: widget.title),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Recent projects",
            style: TextStyle(fontSize: 45),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: _recentProjects(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
