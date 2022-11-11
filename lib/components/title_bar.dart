import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({super.key});

  @override
  State<TitleBar> createState() => _TitleBar();
}

class _TitleBar extends State<TitleBar> with WindowListener {
  void _handleMinimise() async {
    await windowManager.minimize();
  }

  void _handleHorizontalMove(Offset windowPosition) async {
    await windowManager.setPosition(windowPosition);
  }

  void _handleClose() async {
    await windowManager.close();
  }

  Widget _renderLogo() {
    return Row(
      children: const <Widget>[
        SizedBox(
          width: 10,
        ),
        Text(
          "kelodraken",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: "Lobster",
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          "Saga",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            fontFamily: "RobotoThin",
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          "0.0.31 - alpha",
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
          GestureDetector(
            onHorizontalDragStart: (details) async {
              _handleHorizontalMove(await windowManager.getPosition());
            },
            onHorizontalDragUpdate: (details) {
              _handleHorizontalMove(details.globalPosition);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: _renderLogo(),
            ),
          ),
          _renderButtons(),
        ],
      ),
    );
  }
}
