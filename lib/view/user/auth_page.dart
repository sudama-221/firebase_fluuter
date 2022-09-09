import 'package:book_list_project/controller/loading_controller.dart';
import 'package:book_list_project/controller/user/auth_controller.dart';
import 'package:book_list_project/model/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({required this.is_login});
  final bool is_login;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providerから値を監視
    User? user = ref.watch(authControllerProvider);
    // providerから関数を呼ぶ
    final userControllerRead = ref.read(authControllerProvider.notifier);

    bool loadingState = ref.watch(LoadingProvider);
    final loadingStateRead = ref.read(LoadingProvider.notifier);

    bool changePageState = ref.watch(ChangePageProvider);
    final changePageStateRead = ref.read(ChangePageProvider.notifier);

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(is_login ? 'ログイン' : '新規登録'),
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
                    hintText: 'メールアドレス',
                  ),
                  controller: _emailController,
                  onChanged: (value) {
                    print('タイトルをデバッグ: $value');
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'パスワード',
                  ),
                  controller: _passwordController,
                  onChanged: (value) {
                    print('著者をデバッグ: $value');
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    loadingStateRead.startLoading();
                    final email = _emailController.text;
                    final pass = _passwordController.text;
                    try {
                      if (is_login) {
                        // ログインページ
                        await userControllerRead.signIn(email, pass);
                        Navigator.of(context).pop('ログインしました');
                      } else {
                        // 新規登録
                        await userControllerRead.signUp(email, pass);
                        Navigator.of(context).pop('登録完了しました');
                      }
                    } catch (e) {
                      print(e);
                      final snackBar = SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } finally {
                      loadingStateRead.endLoading();
                    }
                  },
                  child: Text(is_login ? 'ログイン' : '登録'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    is_login
                        ? await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthPage(
                                is_login: false,
                              ),
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
                  },
                  child: Text(is_login ? '新規登録の方はこちら' : 'ログインの方はこちら'),
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
      )),
    );
  }
}
