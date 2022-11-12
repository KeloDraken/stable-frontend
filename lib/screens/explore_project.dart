import 'dart:io';

import 'package:flutter/material.dart';
import 'package:git/git.dart';
import 'package:gorom/components/title_bar.dart';
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
  late GitDir _gitDir;
  late List<TreeEntry> _projectTree;

  @override
  void initState() {
    super.initState();
    _getRepoInfo();
  }

  Future<void> _getRepoInfo() async {
    _gitDir = await GitDir.fromExisting(widget.workingDirectory);
    _projectTree = await _getProjectFilesFromCommit(
        "7b34fac3c3064c4e9dce6e7d56accefa983ac211");
    _getRepoName();
    _getCommitCount();
  }

  String _commitsPlural() {
    return _commits == "1" ? "Commit" : "Commits";
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

  Future<List<TreeEntry>> _getProjectFilesFromCommit(String commitHash) async {
    final args = ['ls-tree', '-r', commitHash];

    final pr = await _gitDir.runCommand(args);
    return TreeEntry.fromLsTreeOutput(pr.stdout as String);
  }

  List<DataCell> _renderFiles() {
    List<DataCell> files = [];

    // for (TreeEntry treeEntry in _projectTree) {
    files.add(
      const DataCell(
        Text("videos"),
      ),
    );
    files.add(
      const DataCell(
        Text("Initial commit"),
      ),
    );
    // }

    return files;
  }

  Widget _renderTableHeader() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: const <Widget>[
                Text("Finished scene 33 intro edit"),
                SizedBox(
                  width: 7,
                ),
                Tooltip(
                  message: "Copy commit hash",
                  child: Icon(
                    Icons.copy,
                    size: 15,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text("10 hours ago"),
                const SizedBox(
                  width: 7,
                ),
                Tooltip(
                  message: "$_commits commits made",
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.restore_page_outlined,
                        size: 15,
                      ),
                      Text(_commits),
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
          Text(
            _projectName,
            style: const TextStyle(
                color: Colors.black87,
                decorationThickness: 1.1,
                fontWeight: FontWeight.w600,
                fontSize: 25,
                letterSpacing: 4),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(width: 1),
                  top: BorderSide(width: 1),
                  end: BorderSide(width: 1),
                  start: BorderSide(width: 1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                _renderTableHeader(),
                Text("this is  a test"),
                Text("this is  a test"),
                Text("this is  a test"),
                Text("this is  a test"),
                Text("this is  a test"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
