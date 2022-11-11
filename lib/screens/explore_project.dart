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
  late GitDir gitDir;

  @override
  void initState() {
    super.initState();
    _getRepoInfo();
  }

  Future<void> _getRepoInfo() async {
    gitDir = await GitDir.fromExisting(widget.workingDirectory);
    _getRepoName();
    _getCommitCount();
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
    int commits = await gitDir.commitCount();

    setState(() {
      _commits = commits.toString();
    });
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
                decorationThickness: 2.3,
                fontWeight: FontWeight.w600,
                fontSize: 25,
                letterSpacing: 6),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Commit history".toUpperCase(),
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  _commits,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              const DataColumn(
                label: Text(
                  "Commits",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('1')),
                  DataCell(Text('Stephen')),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
