import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (kDebugMode) print("minimized");
          },
          child: const Icon(Icons.minimize_outlined),
        ),
        ElevatedButton(
          onPressed: () {
            if (kDebugMode) print("maximised");
          },
          child: const Icon(Icons.maximize_outlined),
        ),
        ElevatedButton(
          onPressed: () {
            if (kDebugMode) print("closed");
          },
          child: const Icon(Icons.close_outlined),
        ),
      ],
    );
  }
}
