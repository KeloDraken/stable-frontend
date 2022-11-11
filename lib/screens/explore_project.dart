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

  Widget _renderHeader() {
    return Row(
      children: <Widget>[
        const Text(
          "Working on ",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
          ),
        ),
        Text(
          _projectName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontSize: 17,
          ),
        ),
        const Text(
          " with ",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
          ),
        ),
        Text(
          _commits,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontSize: 17,
          ),
        ),
        const Text(
          "commits",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
          ),
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
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _renderHeader(),
            ),
          ),
        ],
      ),
    );
  }
}
