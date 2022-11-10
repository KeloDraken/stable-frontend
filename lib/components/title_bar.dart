import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key, required this.title});

  final String title;

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

  Widget _renderLogo() {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 6,
        ),
        const Text(
          "kelodraken",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: "Lobster",
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: "RobotoThin",
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        const Text(
          "beta",
          style: TextStyle(
            color: Colors.black45,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _renderButtons() {
    return Row(
      children: [
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
            size: 17,
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
            size: 17,
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
            size: 17,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           Container(
             margin: const EdgeInsets.symmetric(horizontal: 4),
            child: _renderLogo(),
          ),
          _renderButtons(),
        ],
      ),
    );
  }
}
