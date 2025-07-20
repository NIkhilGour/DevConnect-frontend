import 'package:devconnect/tabs/widgets/dummy.dart';
import 'package:flutter/material.dart';

class Groupscreen extends StatelessWidget {
  const Groupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Text('halua');
              },
            );
          },
          icon: Icon(Icons.settings_ethernet)),
    ));
  }
}
