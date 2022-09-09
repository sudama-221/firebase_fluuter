import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../model/book_state.dart';

final bookStateProvider =
    StateNotifierProvider<bookStateNotifier, BookState>((ref) {
  return bookStateNotifier();
});

class bookStateNotifier extends StateNotifier<BookState> {
  bookStateNotifier() : super(const BookState());

  String? id;
  String? title;
  String? author;
  String? imgUrl;

  File? imgFile;

  bool isLoading = false; // ローディング画面を表示するか

  final ImagePicker picker = ImagePicker();

  Future<void> imagePick() async {
    /// 画像を選択
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    imgFile = File(image!.path);

    state = state.copyWith(imgFile: imgFile);
  }

  void imgrefresh() {
    state = state.copyWith(imgFile: null);
  }

  void changeTitle() {
    state = state.copyWith(title: title);
  }
}

//　2022/8/31 モデルファイルが紐づけるから現在のviewファイルも変更できるかも
