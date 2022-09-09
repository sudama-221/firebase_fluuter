import 'package:book_list_project/controller/profile_controller.dart';
import 'package:book_list_project/controller/user/auth_controller.dart';
import 'package:book_list_project/model/user_state.dart';
import 'package:book_list_project/view/user/auth_page.dart';
import 'package:book_list_project/view/user/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserState?> userData =
        ref.watch(profileControllerProvider);

    final authProvider = ref.read(authControllerProvider.notifier);

    return userData.when(data: ((data) {
      if (data != null) {
        print(data);
        UserState userData = data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('マイページ'),
            actions: [
              IconButton(
                  onPressed: () async {
                    // 画面遷移
                    final bool _isEdit = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(userData: userData),
                      ),
                    );
                    if (_isEdit) {
                      const snackBar = SnackBar(
                        content: Text('プロフィールを更新しました'),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          body: Center(
            child: Column(
              children: [
                Text(data.email!),
                Text(data.uid!),
                Text(data.name!),
                Text(data.discription!),
                ElevatedButton(
                  onPressed: (() async {
                    // ログアウト
                    await authProvider.signOut();
                    Navigator.of(context).pop('ログアウトしました');
                  }),
                  child: const Text('ログアウト'),
                )
              ],
            ),
          ),
        );
      } else {
        return const AuthPage(is_login: false);
      }
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
