import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/book.dart';
import '../model/book_list_model.dart';

class AddBookPage extends ConsumerWidget {
  String? title;
  String? author;
  String? id;
  AddBookPage(this.title, this.author, this.id);

  bool isCreate = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providerから値を受け取る
    // final AsyncValue<QuerySnapshot> bookListQuery = ref.watch(BookListProvider);

    final TextEditingController _titleController =
        TextEditingController(text: title);
    final TextEditingController _authorController =
        TextEditingController(text: author);

    return Scaffold(
      appBar: AppBar(
        title: Text('本を追加'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'タイトル',
                ),
                controller: _titleController,
                onChanged: (value) {
                  print('タイトルをデバッグ: $value');
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: '著者',
                ),
                controller: _authorController,
                onChanged: (value) {
                  print('タイトルをデバッグ: $value');
                },
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () async {
                    title = _titleController.text;
                    author = _authorController.text;

                    try {
                      await ref
                          .read(BookListModelProvider.notifier)
                          .addBook(title, author);
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      final snackBar = SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('送信')),
            ],
          ),
        ),
      ),
    );
  }
}
