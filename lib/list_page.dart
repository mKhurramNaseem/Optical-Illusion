import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data'),
      ),
      body: Center(child: ListView.builder(
        itemBuilder: (context, index) {
          return const ListTile(
            title: Text("Khurram"),
            leading: Icon(Icons.home),
            trailing: Icon(Icons.arrow_forward),
          );
        },
      )),
    );
  }
}
