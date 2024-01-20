import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_with_api/views/bottomsheet.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
  List items = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO app'),
        centerTitle: true,
        elevation: 6.0,
        backgroundColor: Colors.purple[200],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const BottomSheetlogic(),
          ));
        },
        backgroundColor: Colors.purpleAccent[100],
        label: const Text('Add'),
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isloading = !isloading;
              getData();
            });
          },
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                );
              }),
        //child: 
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
