import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 59, 65, 68),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Made with ❤️ by Paste Prosmana   ',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
