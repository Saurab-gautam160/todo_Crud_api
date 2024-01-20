import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BottomSheetlogic extends StatefulWidget {
  const BottomSheetlogic({super.key});

  @override
  State<BottomSheetlogic> createState() => _BottomSheetlogicState();
}

class _BottomSheetlogicState extends State<BottomSheetlogic> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descripitionEditingController = TextEditingController();
  final url = 'https://api.nstack.in/v1/todos';
  @override
  void dispose() {
    super.dispose();
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailedMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(backgroundColor: Colors.red),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // for post the data
  Future<void> sumbitData() async {
    //get the data
    final title = titleEditingController.text;
    final descripition = descripitionEditingController.text;
    final body = {
      "title": title,
      "description": descripition,
      "is_completed": false,
    };
    final uri = Uri.parse(url);
    final respone = await http.post(uri,
        //headers of api and 'application/json' is type of header
        body: jsonEncode(body),
        headers: {'content-Type': 'application/json'});

    //sumbit the data

    if (respone.statusCode == 201) {
      //for making empty the textfield after sumbitting the text
      titleEditingController.text = '';
      descripitionEditingController.text = '';

      showSuccessMessage('Succesfully sumbitted ');
    } else {
      showFailedMessage('Error Occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: titleEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Add a new task"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: descripitionEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Descripition"),
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 8,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    sumbitData();
                  },
                  child: const Text('Sumbit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
