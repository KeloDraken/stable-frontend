import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> _openKofi() async {
    Uri uri = Uri.parse("https://flutter.io");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openTwitter() async {
    Uri uri = Uri.parse("https://twitter.com/KeloDraken");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 380,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              foregroundColor: MaterialStateProperty.all(Colors.black45),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text(
              "About",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _openKofi();
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              foregroundColor: MaterialStateProperty.all(Colors.black45),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text(
              "Buy me a Beer",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _openTwitter();
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              foregroundColor: MaterialStateProperty.all(Colors.black45),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text(
              "Feedback",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
