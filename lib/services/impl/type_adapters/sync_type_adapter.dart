import 'package:hive/hive.dart';

import '../../../models/models.dart';

class SyncTypeAdapter extends TypeAdapter<Sync> {
  @override
  Sync read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();
    var offlineFileIds = reader.readIntList();

    return Sync(id: id, name: name, offlineFileIds: offlineFileIds);
  }

  @override
  int get typeId => 101;

  @override
  void write(BinaryWriter writer, Sync obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeIntList(obj.offlineFileIds);
  }
}
