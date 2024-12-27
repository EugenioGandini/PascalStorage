// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteFolderImpl _$$RemoteFolderImplFromJson(Map<String, dynamic> json) =>
    _$RemoteFolderImpl(
      path: json['path'] as String,
      name: json['name'] as String,
      size: (json['size'] as num).toInt(),
      modified: DateTime.parse(json['modified'] as String),
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$$RemoteFolderImplToJson(_$RemoteFolderImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
      'modified': instance.modified.toIso8601String(),
      'selected': instance.selected,
    };
