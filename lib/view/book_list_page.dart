import 'package:book_list_project/controller/user/auth_controller.dart';
import 'package:book_list_project/model/book.dart';
import 'package:book_list_project/view/edit_book_page.dart';
import 'package:book_list_project/view/profile_page.dart';
import 'package:book_list_project/view/user/auth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../controller/book_list_model.dart';

class BookListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providerから値を受け取る
    final AsyncValue<QuerySnapshot> bookListQuery = ref.watch(BookListProvider);

    // 他のページでも一覧表示する場合は再度ファイルを分けてウィジェット化すればいい？

    final user = ref.watch(authControllerProvider);
    print('ログインしている?$user');

    return Scaffold(
      appBar: AppBar(
        title: const Text('本一覧'),
        actions: [
          IconButton(
            onPressed: () async {
              final String? text = user != null
                  ? await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                        fullscreenDialog: true,
                      ))
                  : await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthPage(
                          is_login: true,
                        ),
                        fullscreenDialog: true,
                      ));
              if (text != null) {
                final snackBar = SnackBar(
                  content: Text(text),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: Center(
        child: bookListQuery.when(data: (QuerySnapshot query) {
          // 値が取得できた時
          return ListView(
            children: query.docs.map((document) {
              // 値を格納
              Book bookData = Book(document.id, document['title'],
                  document['author'], document['imgUrl']);

              return Slidable(
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (value) async {
                        // 画面遷移
                        final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(
                                bookData: bookData,
                              ),
                              fullscreenDialog: true,
                            ));

                        if (title != null) {
                          final snackBar = SnackBar(
                            content: Text('$titleを更新しました'),
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
                        await dialog(context, ref, bookData);
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: '削除',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: bookData.imgUrl != null
                      ? Image.network(
                          bookData.imgUrl!,
                          errorBuilder: (c, o, s) {
                            print('Load failed : ${c.toString()}');
                            return const Icon(
                              Icons.error,
                              color: Colors.red,
                            );
                          },
                        )
                      : null,
                  title: Text(bookData.title),
                  subtitle: Text(bookData.author),
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
                builder: (context) => const EditBookPage(
                  bookData: null,
                ),
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

  Future dialog(BuildContext context, WidgetRef ref, Book bookData) {
    return showDialog(
        context: context,
        builder: ((_) {
          return AlertDialog(
            title: Text("削除の確認"),
            content: Text("${bookData.title}を削除しますか？"),
            actions: [
              TextButton(
                  onPressed: (() => Navigator.pop(context)),
                  child: Text("キャンセル")),
              TextButton(
                  onPressed: (() async {
                    try {
                      await ref
                          .read(BookListModelProvider.notifier)
                          .deleteBook(bookData.id);
                      Navigator.pop(context);
                      final snackBar = SnackBar(
                        content: Text("${bookData.title}を削除しました"),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      final snackBar = SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }),
                  child: Text("削除")),
            ],
          );
        }));
  }
}
