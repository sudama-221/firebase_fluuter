import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/book.dart';

class TestException implements Exception {
  final String message;
  const TestException(this.message);

  @override
  String toString() => message;
}
// *********
// プロバイダーの定義
// ***********************

// 本一覧を取得
final BookListProvider = StreamProvider.autoDispose((_) {
  return FirebaseFirestore.instance.collection('books').snapshots();
});

// final EditBookInfo

// 関数を入れたプロバイダー
final BookListModelProvider =
    StateNotifierProvider<BookListModel, dynamic>((ref) {
  return BookListModel();
});

class BookListModel extends StateNotifier<dynamic> {
  BookListModel() : super('');

  Future<void> addBook(dynamic title, dynamic author) async {
    if (title == null || title == "") {
      // throw 'タイトルが入力されていません';
      throw TestException('タイトルが入力されていません');
    }
    if (author == null || author == "") {
      throw '著者が入力されていません';
    }

    await FirebaseFirestore.instance.collection('books').add({
      'title': title,
      'author': author,
    });
  }

  Future<void> updateBook(dynamic document) async {
    if (document.id == null || document.id == "") {
      // throw 'タイトルが入力されていません';
      throw TestException('アイテムが見つかりません');
    }
  }

  Future<void> deleteBook(dynamic document) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(document.id)
        .delete();
  }
}
