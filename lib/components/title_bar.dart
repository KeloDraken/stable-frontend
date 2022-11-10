import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  void _handleMinimise() async {
    await windowManager.minimize();
  }

  void _handleMaximise() async {
    await windowManager.maximize();
  }

  void _handleUnmaximise() async {
    await windowManager.unmaximize();
  }

  void _handleClose() async {
    await windowManager.close();
  }

  void _windowSize() async {
    if (await windowManager.isMaximized()) {
      _handleUnmaximise();
    } else {
      _handleMaximise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _handleMinimise();
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all(
                const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            child: const Icon(
              Icons.minimize_outlined,
              size: 18,
            ),
          ),
          ElevatedButton(
            onPressed: () => _windowSize(),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all(
                const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            child: const Icon(
              Icons.maximize_outlined,
              size: 18,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _handleClose();
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.red),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            child: const Icon(
              Icons.close_outlined,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
