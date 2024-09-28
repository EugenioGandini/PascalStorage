// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileImpl _$$FileImplFromJson(Map<String, dynamic> json) => _$FileImpl(
      path: json['path'] as String,
      name: json['name'] as String,
      size: (json['size'] as num).toInt(),
      modified: DateTime.parse(json['modified'] as String),
      type: json['type'] as String,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$$FileImplToJson(_$FileImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
      'modified': instance.modified.toIso8601String(),
      'type': instance.type,
      'content': instance.content,
    };
