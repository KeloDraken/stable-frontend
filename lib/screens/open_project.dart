import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:git/git.dart';
import 'package:gorom/components/footer.dart';
import 'package:gorom/components/title_bar.dart';
import 'package:path/path.dart' as p;
import 'package:window_manager/window_manager.dart';

import 'explore_project.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProject();
}

class _CreateProject extends State<CreateProject> with WindowListener {
  String _projectDirectory = "";

  void _pushExploreProject(String workingDirectory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ExploreProjectScreen(workingDirectory: workingDirectory);
        },
      ),
    );
  }

  void _createSagaFile() async {
    String projectDirectory = p.canonicalize(_projectDirectory);

    File file = File("$projectDirectory\\project.saga");

    if (!await file.exists()) {
      file.create(recursive: true);
    }

    Map<String, dynamic> content = {};
    content.addAll({"sagaVersion": "0.0.31"});

    ProcessResult pr = await runGit(['rev-parse', '--show-toplevel'],
        processWorkingDir: projectDirectory);

    String projectName = pr.stdout.toString().split('/').last.trim();

    content.addAll({"projectName": projectName});
    content.addAll({"projectDir": projectDirectory});

    file.writeAsStringSync(json.encode(content));
  }

  Future<void> _initNewRepo() async {
    String projectDirectory = p.canonicalize(_projectDirectory);
    _createSagaFile();

    if (await GitDir.isGitDir(projectDirectory)) {
      _pushExploreProject(p.canonicalize(_projectDirectory));
      return;
    }

    await GitDir.init(
      projectDirectory,
      allowContent: true,
      initialBranch: "master",
    );

    // gitDir.
    await runGit(
      ['add', '.'],
      processWorkingDir: _projectDirectory,
    );
    await runGit(
      ['commit', '-m', 'New Saga created'],
      processWorkingDir: _projectDirectory,
    );

    _pushExploreProject(p.canonicalize(_projectDirectory));
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
        children: <Widget>[
          const TitleBar(),
          Expanded(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 78,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: const <Widget>[
                      Text(
                        "Saga is a version control tool for creatives. Restore your files to any point in your project's history.",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "RobotoThin",
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Skapad med ❤ i Göteborg",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "RobotoThin",
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(_projectDirectory),
                ElevatedButton(
                  onPressed: () {
                    _getProjectDirectory();
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(10),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 20),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Text(
                    "Track a project",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "RobotoThin",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
