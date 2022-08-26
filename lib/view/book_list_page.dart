import 'package:book_list_project/domain/book.dart';
import 'package:book_list_project/view/add_book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../model/book_list_model.dart';

class BookListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providerから値を受け取る
    final AsyncValue<QuerySnapshot> bookListQuery = ref.watch(BookListProvider);

    // final List<Book>? books = ref.watch(BookListModelProvider);

    // if (books == null || books.isEmpty) {
    //   print('取れない');
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('本一覧'),
      ),
      body: Center(
        child: bookListQuery.when(data: (QuerySnapshot query) {
          // 値が取得できた時
          return ListView(
            children: query.docs.map((document) {
              return Slidable(
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (value) async {
                        // 画面遷移
                        final bool? added = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBookPage(
                                  document['title'],
                                  document['author'],
                                  document.id),
                              fullscreenDialog: true,
                            ));

                        if (added != null && added) {
                          const snackBar = SnackBar(
                            content: Text('本を追加しました'),
                            backgroundColor: Colors.green,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      backgroundColor: Colors.blue,
                      icon: Icons.edit,
                      label: '編集',
                    ),
                    SlidableAction(
                      onPressed: (value) async {
                        await ref
                            .read(BookListModelProvider.notifier)
                            .deleteBook(document);
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: '削除',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(document['title']),
                  subtitle: Text(document['author']),
                ),
              );
            }).toList(),
          );
        }, error: ((e, stackTrace) {
          return Center(
            child: Text(e.toString()),
          );
        }), loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 画面遷移
          final bool? added = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBookPage(null, null, null),
                fullscreenDialog: true,
              ));

          if (added != null && added) {
            const snackBar = SnackBar(
              content: Text('本を追加しました'),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
