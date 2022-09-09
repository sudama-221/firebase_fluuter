import 'package:book_list_project/model/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInWithEmail(String email, String password);
  Future<UserCredential> signUp(String email, String password);
  User? getCurrentUser();
  Future<void> signOut();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read);
});

class AuthRepository implements BaseAuthRepository {
  final Reader _read;
  const AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  // ログイン
  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw convertAuthError(e.code);
    }
  }

  // 登録
  @override
  Future<UserCredential> signUp(String email, String password) async {
    try {
      final result = await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      throw convertAuthError(e.code);
    }
  }

  // ログインしているユーザー
  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw convertAuthError(e.code);
    }
  }

  // ログアウト
  @override
  Future<void> signOut() async {
    try {
      await _read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      throw convertAuthError(e.code);
    }
  }
}

// エラー文を日本語にする
String convertAuthError(String errorCode) {
  switch (errorCode) {
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください';
    case 'wrong-password':
      return 'パスワードが間違っています';
    case 'user-not-found':
      return 'ユーザーが見つかりません';
    case 'weak-password':
      return 'パスワードは6文字以上で入力してください';
    case 'user-disabled':
      return 'ユーザーが無効です';
    case 'email-already-in-use':
      return 'このメールアドレスは既に登録されています';
    default:
      return '不明なエラーです';
  }
}
