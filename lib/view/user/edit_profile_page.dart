import 'dart:io';

import 'package:book_list_project/controller/loading_controller.dart';
import 'package:book_list_project/controller/profile_controller.dart';
import 'package:book_list_project/model/user_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  // ignore: use_key_in_widget_constructors
  const EditProfilePage({this.userData});
  final UserState? userData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditBookPageState();
}

class _EditBookPageState extends ConsumerState<EditProfilePage> {
  bool _isCreate = false;
  bool _isUpdated = false;

  late String? name;
  late String? discription;

  late TextEditingController? _nameTextController;
  late TextEditingController? _discriptionTextController;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      _isCreate = true;
    }
    var name = widget.userData?.name;
    var discription = widget.userData?.discription;

    print(widget.userData);

    _nameTextController = TextEditingController(text: name);
    _discriptionTextController = TextEditingController(text: discription);
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(profileControllerProvider);
    final userController = ref.read(profileControllerProvider.notifier);

    bool loadingState = ref.watch(LoadingProvider);
    final loadingStateRead = ref.read(LoadingProvider.notifier);

    return userData.when(data: ((data) {
      UserState userData = data!;
      return Scaffold(
        appBar: AppBar(
          title: const Text('profile edit'),
        ),
        body: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '名前',
                      ),
                      controller: _nameTextController,
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
                        hintText: '自己紹介',
                      ),
                      controller: _discriptionTextController,
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
                    ElevatedButton(
                      onPressed: _isUpdated
                          ? () async {
                              loadingStateRead.startLoading();
                              name = _nameTextController!.text;
                              discription = _discriptionTextController!.text;

                              try {
                                await userController.update(name, discription);
                                Navigator.of(context).pop(true);
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
                    Text(userData.name!),
                    Text(userData.discription!)
                  ],
                ),
              ),
              if (loadingState)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      );
    }), error: ((e, stackTrace) {
      return Center(
        child: Text(e.toString()),
      );
    }), loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
