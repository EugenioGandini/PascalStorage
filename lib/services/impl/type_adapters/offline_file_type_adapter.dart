import 'package:hive/hive.dart';

import '../../../models/models.dart';

class OfflineFileTypeAdapter extends TypeAdapter<OfflineFile> {
  @override
  OfflineFile read(BinaryReader reader) {
    var localCopy = ResourceFile(
      path: reader.readString(),
      name: reader.readString(),
      size: reader.readInt(),
      modified: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      type: reader.readString(),
    );

    ResourceFile remoteCopy = ResourceFile(
      path: reader.readString(),
      name: reader.readString(),
      size: reader.readInt(),
      modified: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      type: reader.readString(),
    );

    var synchronize = reader.readBool();

    return OfflineFile(
      localCopy: localCopy,
      remoteCopy: remoteCopy,
      synchronize: synchronize,
    );
  }

  @override
  int get typeId => 100;

  @override
  void write(BinaryWriter writer, OfflineFile obj) {
    var localCopy = obj.localCopy;

    // offline data file
    writer.writeString(localCopy.path);
    writer.writeString(localCopy.name);
    writer.writeInt(localCopy.size);
    writer.writeInt(localCopy.modified.millisecondsSinceEpoch);
    writer.writeString(localCopy.type);

    var remoteCopy = obj.remoteCopy;

    // remote data file
    writer.writeString(remoteCopy.path);
    writer.writeString(remoteCopy.name);
    writer.writeInt(remoteCopy.size);
    writer.writeInt(remoteCopy.modified.millisecondsSinceEpoch);
    writer.writeString(remoteCopy.type);

    writer.writeBool(obj.synchronize);
  }
}
