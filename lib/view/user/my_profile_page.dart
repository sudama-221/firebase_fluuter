import 'package:book_list_project/controller/profile_controller.dart';
import 'package:book_list_project/controller/user/auth_controller.dart';
import 'package:book_list_project/model/user_state.dart';
import 'package:book_list_project/view/user/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserState?> userData =
        ref.watch(profileControllerProvider);

    final authProvider = ref.read(authControllerProvider.notifier);

    return userData.when(data: ((data) {
      if (data != null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('マイページ'),
          ),
          body: Center(
            child: Column(
              children: [
                Text(data.email!),
                Text(data.uid!),
                ElevatedButton(
                  onPressed: (() async {
                    // ログアウト
                    await authProvider.signOut();
                    Navigator.of(context).pop();
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
