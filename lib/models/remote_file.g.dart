// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteFileImpl _$$RemoteFileImplFromJson(Map<String, dynamic> json) =>
    _$RemoteFileImpl(
      path: json['path'] as String,
      name: json['name'] as String,
      size: (json['size'] as num).toInt(),
      modified: DateTime.parse(json['modified'] as String),
      type: json['type'] as String,
      content: json['content'] as String?,
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$$RemoteFileImplToJson(_$RemoteFileImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
      'modified': instance.modified.toIso8601String(),
      'type': instance.type,
      'content': instance.content,
      'selected': instance.selected,
    };
