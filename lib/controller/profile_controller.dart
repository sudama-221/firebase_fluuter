import 'dart:async';
import 'package:book_list_project/model/user_state.dart';
import 'package:book_list_project/repository/auth_repository.dart';
import 'package:book_list_project/repository/user_repository.dart';
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

final profileControllerProvider = StateNotifierProvider.autoDispose<
    profileControllerNotifier, AsyncValue<UserState?>>((ref) {
  return profileControllerNotifier(ref.read);
});

class profileControllerNotifier extends StateNotifier<AsyncValue<UserState?>> {
  final Reader _read;
  profileControllerNotifier(this._read) : super(const AsyncLoading()) {
    getCurrentUserState();
  }

  // プロフィール取得
  Future<void> getCurrentUserState() async {
    try {
      final userData =
          await _read(firebaseStorageProvider).getCurrentUserState();
      state = AsyncValue.data(userData);
    } catch (e) {
      throw e.toString();
    }
  }

  // プロフィール情報
  Future<void> update(String? name, String? discription) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'discription': discription,
    });
    getCurrentUserState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ログイン
  Future<void> signIn(String email, String password) async {
    try {
      await _read(authRepositoryProvider).signInWithEmail(email, password);
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
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
