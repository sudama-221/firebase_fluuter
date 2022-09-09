import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../model/book.dart';

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

// 関数を入れたプロバイダー
final BookListModelProvider =
    StateNotifierProvider<BookListModel, dynamic>((ref) {
  return BookListModel();
});

class BookListModel extends StateNotifier<dynamic> {
  BookListModel() : super('');

  Future<void> addBook(dynamic title, dynamic author, dynamic imgFile) async {
    final doc = FirebaseFirestore.instance.collection('books').doc();
    String? imgUrl;

    if (title == null || title == "") {
      throw TestException('タイトルが入力されていません');
    }
    if (author == null || author == "") {
      throw '著者が入力されていません';
    }

    if (imgFile != null) {
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        // contentType: 'image/png',
        customMetadata: {'picked-file-path': imgFile.path},
      );
      UploadTask uploadTask;
      Reference ref =
          FirebaseStorage.instance.ref().child('books').child('/${doc.id}.jpg');

      try {
        // storageにアップロード
        uploadTask = ref.putData(await imgFile.readAsBytes(), metadata);
        imgUrl = await (await uploadTask).ref.getDownloadURL();
      } catch (e) {
        print(e.toString());
      }
      // UploadTask uploadTask = storageReference.putFile(imgFile, metadata);
    } else {
      print('画像がない');
    }

    await doc.set({'title': title, 'author': author, 'imgUrl': imgUrl});
  }

  Future<void> updateBook(dynamic id, dynamic title, dynamic author) async {
    if (title == null || title == "") {
      // throw 'タイトルが入力されていません';
      throw TestException('タイトルが入力されていません');
    }
    if (author == null || author == "") {
      // throw 'タイトルが入力されていません';
      throw TestException('著者が入力されていません');
    }

    await FirebaseFirestore.instance.collection('books').doc(id).update({
      'title': title,
      'author': author,
    });
  }

  Future<void> deleteBook(String id) async {
    await FirebaseFirestore.instance.collection('books').doc(id).delete();
  }
}
