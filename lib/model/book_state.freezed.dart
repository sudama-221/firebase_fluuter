// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'book_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BookState {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  File? get imgFile => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BookStateCopyWith<BookState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookStateCopyWith<$Res> {
  factory $BookStateCopyWith(BookState value, $Res Function(BookState) then) =
      _$BookStateCopyWithImpl<$Res>;
  $Res call({String? id, String? title, String? author, File? imgFile});
}

/// @nodoc
class _$BookStateCopyWithImpl<$Res> implements $BookStateCopyWith<$Res> {
  _$BookStateCopyWithImpl(this._value, this._then);

  final BookState _value;
  // ignore: unused_field
  final $Res Function(BookState) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? imgFile = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      imgFile: imgFile == freezed
          ? _value.imgFile
          : imgFile // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

/// @nodoc
abstract class _$$_BookStateCopyWith<$Res> implements $BookStateCopyWith<$Res> {
  factory _$$_BookStateCopyWith(
          _$_BookState value, $Res Function(_$_BookState) then) =
      __$$_BookStateCopyWithImpl<$Res>;
  @override
  $Res call({String? id, String? title, String? author, File? imgFile});
}

/// @nodoc
class __$$_BookStateCopyWithImpl<$Res> extends _$BookStateCopyWithImpl<$Res>
    implements _$$_BookStateCopyWith<$Res> {
  __$$_BookStateCopyWithImpl(
      _$_BookState _value, $Res Function(_$_BookState) _then)
      : super(_value, (v) => _then(v as _$_BookState));

  @override
  _$_BookState get _value => super._value as _$_BookState;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? imgFile = freezed,
  }) {
    return _then(_$_BookState(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      imgFile: imgFile == freezed
          ? _value.imgFile
          : imgFile // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

/// @nodoc

class _$_BookState implements _BookState {
  const _$_BookState({this.id, this.title, this.author, this.imgFile});

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? author;
  @override
  final File? imgFile;

  @override
  String toString() {
    return 'BookState(id: $id, title: $title, author: $author, imgFile: $imgFile)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BookState &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.author, author) &&
            const DeepCollectionEquality().equals(other.imgFile, imgFile));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(author),
      const DeepCollectionEquality().hash(imgFile));

  @JsonKey(ignore: true)
  @override
  _$$_BookStateCopyWith<_$_BookState> get copyWith =>
      __$$_BookStateCopyWithImpl<_$_BookState>(this, _$identity);
}

abstract class _BookState implements BookState {
  const factory _BookState(
      {final String? id,
      final String? title,
      final String? author,
      final File? imgFile}) = _$_BookState;

  @override
  String? get id;
  @override
  String? get title;
  @override
  String? get author;
  @override
  File? get imgFile;
  @override
  @JsonKey(ignore: true)
  _$$_BookStateCopyWith<_$_BookState> get copyWith =>
      throw _privateConstructorUsedError;
}
