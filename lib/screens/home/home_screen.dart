import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.blue.withOpacity(0.4),
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/documents');
                  },
                  child: Text(
                    'My Documents',
                    style: Theme.of(context).textTheme.headline6,
                  )),
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.red.withOpacity(0.4),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/new-document');
              },
              child: Text('Create a New Document',
                  style: Theme.of(context).textTheme.headline6),
            ),
          )),
        ],
      ),
    );
  }
}
