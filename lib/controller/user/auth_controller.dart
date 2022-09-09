import 'dart:async';
import 'package:book_list_project/model/user_state.dart';
import 'package:book_list_project/repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final UserStateProvider =
    StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  return UserStateNotifier();
});

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(const UserState());

  String? email;
  String? password;

  Future signup(UserState userData) async {
    email = userData.email;
    password = userData.password;

    if (email == null || email == "") {
      throw 'メールアドレスを記入してください';
    }
    if (password == null || password == "") {
      throw 'パスワードを記入してください';
    }
    // firebase authでユーザー認証
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    final user = userCredential.user;

    if (user != null) {
      final uid = user.uid;

      // firestoreに追加
      final doc = FirebaseFirestore.instance.collection('users').doc(uid);
      await doc.set({'uid': uid, 'email': email});
    }
  }

  // ログイン
  Future login(UserState user) async {
    email = user.email;
    password = user.password;

    if (email == null || email == "") {
      throw 'メールアドレスを記入してください';
    }
    if (password == null || password == "") {
      throw 'パスワードを記入してください';
    }

    // firebase authでユーザー認証
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  //　ログインしているユーザー情報
  void fetchUser() {
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email;

    state = state.copyWith(email: email);
  }
}

final ChangePageProvider =
    StateNotifierProvider<ChangePageNotifier, bool>((ref) {
  return ChangePageNotifier();
});

class ChangePageNotifier extends StateNotifier<bool> {
  ChangePageNotifier() : super(false);

  bool change = false;

  void changeFun(bool is_change) {
    change = is_change;
    state = change;
  }
}

final authControllerProvider =
    StateNotifierProvider.autoDispose<authControllerNotifier, User?>((ref) {
  return authControllerNotifier(ref.read);
});

class authControllerNotifier extends StateNotifier<User?> {
  final Reader _read;
  authControllerNotifier(this._read) : super(null);

  @override
  User? get state => _read(authRepositoryProvider).getCurrentUser();

  @override
  void dispose() {
    super.dispose();
  }

  // ログイン
  Future<void> signIn(String email, String password) async {
    try {
      await _read(authRepositoryProvider).signInWithEmail(email, password);
      state = state;
    } catch (e) {
      throw e.toString();
    }
  }

  // 登録
  Future<void> signUp(String email, String password) async {
    try {
      // firebaAuthに登録
      final userCredential =
          await _read(authRepositoryProvider).signUp(email, password);

      final user = userCredential.user;
      if (user != null) {
        final uid = user.uid;
        // firestoreに追加
        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        await doc.set({'uid': uid, 'email': email});

        state = state;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _read(authRepositoryProvider).signOut();
    state = null;
    print(state);
  }
}
