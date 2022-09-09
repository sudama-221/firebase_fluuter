import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_state.freezed.dart';

@freezed
class BookState with _$BookState {
  const factory BookState({
    String? id,
    String? title,
    String? author,
    File? imgFile,
  }) = _BookState;
}
