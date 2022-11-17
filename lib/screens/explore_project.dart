import 'dart:io';

import 'package:flutter/material.dart';
import 'package:git/git.dart';
import 'package:gorom/components/title_bar.dart';
import 'package:gorom/main.dart';
import 'package:window_manager/window_manager.dart';

class ExploreProjectScreen extends StatelessWidget {
  const ExploreProjectScreen({super.key, required this.workingDirectory});

  final String workingDirectory;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sága',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "RobotoRegular",
      ),
      home: ExploreProject(workingDirectory: workingDirectory),
    );
  }
}

class ExploreProject extends StatefulWidget {
  const ExploreProject({super.key, required this.workingDirectory});

  final String workingDirectory;

  @override
  State<ExploreProject> createState() => _ExploreProject();
}

class _ExploreProject extends State<ExploreProject> with WindowListener {
  String _projectName = "";
  String _lastCommitMessage = "";
  String _lastCommitHash = "";
  String _newCommitMessage = "";
  late Map<String, Commit> _commitHistory = {};
  late GitDir _gitDir;

  @override
  void initState() {
    super.initState();
    _getRepoInfo();
  }

  Future<void> _getRepoInfo() async {
    _gitDir = await GitDir.fromExisting(widget.workingDirectory);
    _getRepoName();
    _getLastCommit();
    _logCommits();
  }

  Future<void> _getRepoName() async {
    ProcessResult pr = await runGit(['rev-parse', '--show-toplevel'],
        processWorkingDir: widget.workingDirectory);

    List<String> proName = pr.stdout.toString().split('/');

    setState(() {
      _projectName = proName.last.trim();
    });
  }

  Future<void> _logCommits() async {
    Map<String, Commit> commits = await _gitDir.commits();

    setState(() {
      _commitHistory = commits;
    });
  }

  Future<void> _getLastCommit() async {
    ProcessResult lastCommit = await runGit(['rev-parse', 'HEAD'],
        processWorkingDir: widget.workingDirectory);

    ProcessResult lastCommitMessage = await runGit(
        ['show', '-s', '--format=%s'],
        processWorkingDir: widget.workingDirectory);

    setState(() {
      _lastCommitMessage = lastCommitMessage.stdout.toString().trim();
      _lastCommitHash = lastCommit.stdout.toString();
    });
  }

  Future<void> _resetProjectToLastCommit() async {
    await runGit(['reset', '--hard', _lastCommitHash],
        processWorkingDir: widget.workingDirectory);
  }

  Widget _renderTableHeader() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Tooltip(
              message: "Your last restore point",
              child: Text(
                _lastCommitMessage,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: "RobotoThin",
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Tooltip(
              message: "Reset project to this point",
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  "Restore",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "RobotoRegular",
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  _resetProjectToLastCommit();
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Reset Successful"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: const Text(
                              "Done",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: "RobotoThin",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _setCommitMessage(String text) {
    setState(() {
      _newCommitMessage = text;
    });
  }

  void _createNewCommit() {
    _gitDir.runCommand(["add", "."]);
    _gitDir.runCommand(["commit", "-m", _newCommitMessage]);
    _getLastCommit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const TitleBar(),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  tooltip: "Create new restore point",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Save current project state"),
                        content: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (String? text) {
                            if (text != null) _setCommitMessage(text);
                          },
                          decoration: const InputDecoration(
                            label: Text(
                              "Petrol",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: "RobotoThin",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _createNewCommit();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: const Text(
                                "Create restore point",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontFamily: "RobotoThin",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_as_outlined),
                ),
                Text(
                  _projectName,
                  style: const TextStyle(
                    color: Colors.black87,
                    decorationThickness: 1.1,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    letterSpacing: 4,
                  ),
                ),
                IconButton(
                  tooltip: "Close project",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(width: 2),
                top: BorderSide(width: 2),
                end: BorderSide(width: 2),
                start: BorderSide(width: 2),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            margin: const EdgeInsets.all(10),
            child: Material(
              elevation: 10,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Colors.black),
                    child: _renderTableHeader(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    child: const Text(
                      "PROJECT HISTORY",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text("this is  a test"),
                  Text("this is  a test"),
                  Text("this is  a test"),
                  Text("this is  a test"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
