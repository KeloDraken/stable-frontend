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
        children: <Widget>[
          TitleBar(title: widget.title),
          const SizedBox(
            height: 100,
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
                  "Made with ❤ in Gothenburg",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "RobotoThin",
                      fontWeight: FontWeight.w600),
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
                  const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
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
          SizedBox(
            height: 250,
            width: 380,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    foregroundColor: MaterialStateProperty.all(Colors.black45),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text(
                    "ℹAbout",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    foregroundColor: MaterialStateProperty.all(Colors.black45),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text(
                    "🍻Buy me a Beer",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    foregroundColor: MaterialStateProperty.all(Colors.black45),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text(
                    "📄Licence",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
