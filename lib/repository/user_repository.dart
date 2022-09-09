import 'package:book_list_project/model/user_state.dart';
import 'package:book_list_project/repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

abstract class BaseFirestoreRepository {
  Future<UserState> getCurrentUserState();
}

final firebaseStorageProvider = Provider<FirebaseStorageRepository>((ref) {
  return FirebaseStorageRepository(ref.read);
});

class FirebaseStorageRepository implements BaseFirestoreRepository {
  final Reader _read;
  const FirebaseStorageRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  // ログインしているユーザー
  @override
  Future<UserState> getCurrentUserState() async {
    try {
      final currentUser = _read(firebaseAuthProvider).currentUser;
      final snapshot = await _read(firestoreProvider)
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      final data = snapshot.data();

      final email = data?['email'];
      final uid = data?['uid'];
      final name = data?['name'];
      final discription = data?['discription'];

      return UserState(
          uid: uid, email: email, name: name, discription: discription);
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
