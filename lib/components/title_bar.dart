import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  void _windowManagerChecks() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
  }

  void _handleMinimise() async {
    _windowManagerChecks();
    await windowManager.minimize();
  }

  void _handleMaximise() async {
    _windowManagerChecks();
    await windowManager.maximize();
  }

  void _handleUnmaximise() async {
    _windowManagerChecks();
    await windowManager.unmaximize();
  }

  void _handleClose() async {
    _windowManagerChecks();
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
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _handleMinimise();
            },
            child: const Icon(Icons.minimize_outlined),
          ),
          ElevatedButton(
            onPressed: () => _windowSize(),
            child: const Icon(Icons.maximize_outlined),
          ),
          ElevatedButton(
            onPressed: () {
              _handleClose();
            },
            child: const Icon(Icons.close_outlined),
          ),
        ],
      ),
    );
  }
}
