import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:git/git.dart';
import 'package:gorom/components/title_bar.dart';
import 'package:path/path.dart' as p;
import 'package:window_manager/window_manager.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key, required this.title});

  final String title;

  @override
  State<CreateProject> createState() => _CreateProject();
}

class _CreateProject extends State<CreateProject> with WindowListener {
  String _projectDirectory = "";

  Future<void> _initNewRepo() async {
    String projectDirectory = p.canonicalize(_projectDirectory);

    if (await GitDir.isGitDir(projectDirectory)) {
      print("A Saga exists in this directory");
      return;
    }

    await GitDir.init(
      projectDirectory,
      allowContent: true,
      initialBranch: "master",
    );

    await runGit(
      ['add', '.'],
      processWorkingDir: _projectDirectory.toString(),
    );
    await runGit(
      ['commit', '-m', 'Initial commit'],
      processWorkingDir: _projectDirectory.toString(),
    );

    return;
  }

  Future<void> _getProjectDirectory() async {
    String? projectDirectory = await FilePicker.platform.getDirectoryPath();

    if (projectDirectory == null) return;

    setState(() {
      _projectDirectory = projectDirectory;
    });
    _initNewRepo();
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
          Text(_projectDirectory),
          ElevatedButton(
            onPressed: () {
              _getProjectDirectory();
            },
            child: const Text("Create a new Saga"),
          )
        ],
      ),
    );
  }
}
