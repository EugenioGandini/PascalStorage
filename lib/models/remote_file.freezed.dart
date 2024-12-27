// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RemoteFile _$RemoteFileFromJson(Map<String, dynamic> json) {
  return _RemoteFile.fromJson(json);
}

/// @nodoc
mixin _$RemoteFile {
  String get path => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  DateTime get modified => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;

  /// Serializes this RemoteFile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RemoteFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteFileCopyWith<RemoteFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteFileCopyWith<$Res> {
  factory $RemoteFileCopyWith(
          RemoteFile value, $Res Function(RemoteFile) then) =
      _$RemoteFileCopyWithImpl<$Res, RemoteFile>;
  @useResult
  $Res call(
      {String path,
      String name,
      int size,
      DateTime modified,
      String type,
      String? content,
      bool selected});
}

/// @nodoc
class _$RemoteFileCopyWithImpl<$Res, $Val extends RemoteFile>
    implements $RemoteFileCopyWith<$Res> {
  _$RemoteFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? name = null,
    Object? size = null,
    Object? modified = null,
    Object? type = null,
    Object? content = freezed,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      modified: null == modified
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoteFileImplCopyWith<$Res>
    implements $RemoteFileCopyWith<$Res> {
  factory _$$RemoteFileImplCopyWith(
          _$RemoteFileImpl value, $Res Function(_$RemoteFileImpl) then) =
      __$$RemoteFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String path,
      String name,
      int size,
      DateTime modified,
      String type,
      String? content,
      bool selected});
}

/// @nodoc
class __$$RemoteFileImplCopyWithImpl<$Res>
    extends _$RemoteFileCopyWithImpl<$Res, _$RemoteFileImpl>
    implements _$$RemoteFileImplCopyWith<$Res> {
  __$$RemoteFileImplCopyWithImpl(
      _$RemoteFileImpl _value, $Res Function(_$RemoteFileImpl) _then)
      : super(_value, _then);

  /// Create a copy of RemoteFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? name = null,
    Object? size = null,
    Object? modified = null,
    Object? type = null,
    Object? content = freezed,
    Object? selected = null,
  }) {
    return _then(_$RemoteFileImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      modified: null == modified
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteFileImpl extends _RemoteFile {
  const _$RemoteFileImpl(
      {required this.path,
      required this.name,
      required this.size,
      required this.modified,
      required this.type,
      this.content,
      this.selected = false})
      : super._();

  factory _$RemoteFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteFileImplFromJson(json);

  @override
  final String path;
  @override
  final String name;
  @override
  final int size;
  @override
  final DateTime modified;
  @override
  final String type;
  @override
  final String? content;
  @override
  @JsonKey()
  final bool selected;

  @override
  String toString() {
    return 'RemoteFile(path: $path, name: $name, size: $size, modified: $modified, type: $type, content: $content, selected: $selected)';
  }

  /// Create a copy of RemoteFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteFileImplCopyWith<_$RemoteFileImpl> get copyWith =>
      __$$RemoteFileImplCopyWithImpl<_$RemoteFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteFileImplToJson(
      this,
    );
  }
}

abstract class _RemoteFile extends RemoteFile {
  const factory _RemoteFile(
      {required final String path,
      required final String name,
      required final int size,
      required final DateTime modified,
      required final String type,
      final String? content,
      final bool selected}) = _$RemoteFileImpl;
  const _RemoteFile._() : super._();

  factory _RemoteFile.fromJson(Map<String, dynamic> json) =
      _$RemoteFileImpl.fromJson;

  @override
  String get path;
  @override
  String get name;
  @override
  int get size;
  @override
  DateTime get modified;
  @override
  String get type;
  @override
  String? get content;
  @override
  bool get selected;

  /// Create a copy of RemoteFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteFileImplCopyWith<_$RemoteFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
