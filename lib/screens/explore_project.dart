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
  String _commits = "";
  String _lastCommitMessage = "";
  late GitDir _gitDir;
  late List<TreeEntry> _projectTree;

  @override
  void initState() {
    super.initState();
    _getRepoInfo();
  }

  Future<void> _getRepoInfo() async {
    _gitDir = await GitDir.fromExisting(widget.workingDirectory);
    _projectTree = await _getProjectFilesFromCommit();
    _getRepoName();
    _getCommitCount();
  }

  String _commitsPlural() {
    return _commits == "1" ? "commit" : "commits";
  }

  Future<void> _getRepoName() async {
    ProcessResult pr = await runGit(['rev-parse', '--show-toplevel'],
        processWorkingDir: widget.workingDirectory);

    List<String> proName = pr.stdout.toString().split('/');

    setState(() {
      _projectName = proName.last;
    });
  }

  Future<void> _getCommitCount() async {
    int commits = await _gitDir.commitCount();

    setState(() {
      _commits = commits.toString();
    });
  }

  Future<List<TreeEntry>> _getProjectFilesFromCommit() async {
    ProcessResult lastCommit = await runGit(['rev-parse', 'HEAD'],
        processWorkingDir: widget.workingDirectory);

    ProcessResult lastCommitMessage = await runGit(
        ['show', '-s', '--format=%s'],
        processWorkingDir: widget.workingDirectory);

    setState(() {
      _lastCommitMessage = lastCommitMessage.stdout.toString();
    });

    final args = ['ls-tree', '-r', lastCommit.stdout.toString()];

    final pr = await _gitDir.runCommand(args);
    List<TreeEntry> treeEntry = TreeEntry.fromLsTreeOutput(pr.stdout as String);
    return treeEntry;
  }

  Widget _renderTableHeader() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  _lastCommitMessage,
                  style: const TextStyle(
                      fontSize: 17,
                      fontFamily: "RobotoThin",
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Tooltip(
                  message: "Copy commit hash",
                  child: Icon(
                    Icons.copy,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text(
                  "10 hours ago",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "RobotoThin",
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Tooltip(
                  message: "$_commits ${_commitsPlural()} made",
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.restore_page_outlined,
                        size: 15,
                        color: Colors.white,
                      ),
                      Text(
                        _commits,
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: "RobotoThin",
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
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
                const Icon(Icons.info_outline),
                Text(
                  _projectName,
                  style: const TextStyle(
                      color: Colors.black87,
                      decorationThickness: 1.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      letterSpacing: 4),
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
                borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  Text("this is  a test"),
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
