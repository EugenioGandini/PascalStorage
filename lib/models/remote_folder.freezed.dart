// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RemoteFolder _$RemoteFolderFromJson(Map<String, dynamic> json) {
  return _RemoteFolder.fromJson(json);
}

/// @nodoc
mixin _$RemoteFolder {
  String get path => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  DateTime get modified => throw _privateConstructorUsedError;

  /// Serializes this RemoteFolder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RemoteFolder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteFolderCopyWith<RemoteFolder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteFolderCopyWith<$Res> {
  factory $RemoteFolderCopyWith(
          RemoteFolder value, $Res Function(RemoteFolder) then) =
      _$RemoteFolderCopyWithImpl<$Res, RemoteFolder>;
  @useResult
  $Res call({String path, String name, int size, DateTime modified});
}

/// @nodoc
class _$RemoteFolderCopyWithImpl<$Res, $Val extends RemoteFolder>
    implements $RemoteFolderCopyWith<$Res> {
  _$RemoteFolderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteFolder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? name = null,
    Object? size = null,
    Object? modified = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoteFolderImplCopyWith<$Res>
    implements $RemoteFolderCopyWith<$Res> {
  factory _$$RemoteFolderImplCopyWith(
          _$RemoteFolderImpl value, $Res Function(_$RemoteFolderImpl) then) =
      __$$RemoteFolderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String name, int size, DateTime modified});
}

/// @nodoc
class __$$RemoteFolderImplCopyWithImpl<$Res>
    extends _$RemoteFolderCopyWithImpl<$Res, _$RemoteFolderImpl>
    implements _$$RemoteFolderImplCopyWith<$Res> {
  __$$RemoteFolderImplCopyWithImpl(
      _$RemoteFolderImpl _value, $Res Function(_$RemoteFolderImpl) _then)
      : super(_value, _then);

  /// Create a copy of RemoteFolder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? name = null,
    Object? size = null,
    Object? modified = null,
  }) {
    return _then(_$RemoteFolderImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteFolderImpl extends _RemoteFolder {
  const _$RemoteFolderImpl(
      {required this.path,
      required this.name,
      required this.size,
      required this.modified})
      : super._();

  factory _$RemoteFolderImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteFolderImplFromJson(json);

  @override
  final String path;
  @override
  final String name;
  @override
  final int size;
  @override
  final DateTime modified;

  @override
  String toString() {
    return 'RemoteFolder(path: $path, name: $name, size: $size, modified: $modified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteFolderImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.modified, modified) ||
                other.modified == modified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, path, name, size, modified);

  /// Create a copy of RemoteFolder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteFolderImplCopyWith<_$RemoteFolderImpl> get copyWith =>
      __$$RemoteFolderImplCopyWithImpl<_$RemoteFolderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteFolderImplToJson(
      this,
    );
  }
}

abstract class _RemoteFolder extends RemoteFolder {
  const factory _RemoteFolder(
      {required final String path,
      required final String name,
      required final int size,
      required final DateTime modified}) = _$RemoteFolderImpl;
  const _RemoteFolder._() : super._();

  factory _RemoteFolder.fromJson(Map<String, dynamic> json) =
      _$RemoteFolderImpl.fromJson;

  @override
  String get path;
  @override
  String get name;
  @override
  int get size;
  @override
  DateTime get modified;

  /// Create a copy of RemoteFolder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteFolderImplCopyWith<_$RemoteFolderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
