import 'dart:io';

import 'package:book_list_project/controller/loading_controller.dart';
import 'package:book_list_project/model/book_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/picker_image_controller.dart';
import '../model/book.dart';
import '../controller/book_list_model.dart';

class EditBookPage extends ConsumerStatefulWidget {
  // ignore: use_key_in_widget_constructors
  const EditBookPage({this.bookData});
  final Book? bookData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditBookPageState();
}

class _EditBookPageState extends ConsumerState<EditBookPage> {
  bool _isCreate = false;
  bool _isUpdated = false;

  late String title;
  late String author;

  late TextEditingController _titleController;
  late TextEditingController _authorController;

  late String id;

  @override
  void initState() {
    super.initState();
    if (widget.bookData != null) {
      _isCreate = true;
    }
    var id = widget.bookData?.id;
    var title = widget.bookData?.title;
    var author = widget.bookData?.author;

    _titleController = TextEditingController(text: title);
    _authorController = TextEditingController(text: author);
  }

  @override
  Widget build(BuildContext context) {
    BookState bookState = ref.watch(bookStateProvider);
    bool loadingState = ref.watch(LoadingProvider);

    final bookStateRead = ref.read(bookStateProvider.notifier);
    final loadingStateRead = ref.read(LoadingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isCreate ? '本を編集' : '本を追加'),
      ),
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 100,
                      height: 160,
                      child: bookState.imgFile != null
                          ? Image.file(bookState.imgFile!)
                          : Container(
                              color: Colors.grey,
                            ),
                    ),
                    onTap: () async {
                      await ref.read(bookStateProvider.notifier).imagePick();
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'タイトル',
                    ),
                    controller: _titleController,
                    onChanged: (value) {
                      print('タイトルをデバッグ: $value');
                      setState(() {
                        _isUpdated = true;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '著者',
                    ),
                    controller: _authorController,
                    onChanged: (value) {
                      print('著者をデバッグ: $value');
                      setState(() {
                        _isUpdated = true;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                      onPressed: (() async {
                        // imagePickerで画像を選択する
                        final pickerFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickerFile == null) {
                          return;
                        }

                        File file = File(pickerFile.path);
                        // FirebaseStorage storage = FirebaseStorage.instance;
                        try {
                          await addStorage(file, 'puripru');
                        } catch (e) {
                          print(e);
                        }
                        ref.read(bookStateProvider.notifier).imgrefresh();
                      }),
                      child: Text('画像だけ試し')),
                  ElevatedButton(
                    onPressed: _isUpdated
                        ? () async {
                            loadingStateRead.startLoading();
                            title = _titleController.text;
                            author = _authorController.text;

                            try {
                              if (_isCreate == true) {
                                await ref
                                    .read(BookListModelProvider.notifier)
                                    .updateBook(
                                        widget.bookData!.id, title, author);
                                Navigator.of(context).pop(title);
                              } else {
                                await ref
                                    .read(BookListModelProvider.notifier)
                                    .addBook(title, author, bookState.imgFile);
                                Navigator.of(context).pop(true);
                              }
                            } catch (e) {
                              print(e);
                              final snackBar = SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              loadingStateRead.endLoading();
                            }
                          }
                        : null,
                    child: const Text('送信'),
                  ),
                ],
              ),
            ),
            if (loadingState)
              Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<String> addStorage(File image, String id) async {
  final addStorage = FirebaseStorage.instance.ref().child(id);
  final uploadData = addStorage.putFile(image);
  return uploadData
      .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
}
// class AddBookPage extends ConsumerWidget {
//   Book? bookData;
//   AddBookPage(this.bookData);

//   bool _isCreate = false;
//   bool _isUpdated = false;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // providerから値を受け取る
//     // final AsyncValue<QuerySnapshot> bookListQuery = ref.watch(BookListProvider);

//     if (bookData != null) {
//       _isCreate = true;
//     }

//     var title = bookData?.title;
//     var author = bookData?.author;

//     final TextEditingController _titleController =
//         TextEditingController(text: title);
//     final TextEditingController _authorController =
//         TextEditingController(text: author);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isCreate ? '本を編集' : '本を追加'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'タイトル',
//                 ),
//                 controller: _titleController,
//                 onChanged: (value) {
//                   print('タイトルをデバッグ: $value');
//                   ref.read(updatedBookProvider.notifier).isUpdated();
//                 },
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: '著者',
//                 ),
//                 controller: _authorController,
//                 onChanged: (value) {
//                   print('著者をデバッグ: $value');
//                   _isUpdated = true;
//                 },
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               ElevatedButton(
//                   onPressed: _isUpdated
//                       ? () async {
//                           title = _titleController.text;
//                           author = _authorController.text;

//                           try {
//                             await ref
//                                 .read(BookListModelProvider.notifier)
//                                 .updateBook(bookData!.id, title, author);
//                             Navigator.of(context).pop(true);
//                           } catch (e) {
//                             final snackBar = SnackBar(
//                               content: Text(e.toString()),
//                               backgroundColor: Colors.red,
//                             );
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(snackBar);
//                           }
//                         }
//                       : null,
//                   child: Text('送信')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
