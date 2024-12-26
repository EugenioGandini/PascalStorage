import 'package:flutter_test/flutter_test.dart';

import 'package:pascalstorage/models/remote_folder.dart';
import 'package:pascalstorage/pages/my_storage/widgets/folder_widget.dart';

void main() {
  testWidgets('Show folder sample widget', (tester) async {
    RemoteFolder folder = RemoteFolder(
      name: 'Cartella1',
      path: '/Home/Folder/Subfolder',
      size: 0,
      modified: DateTime.now(),
    );

    await tester.pumpWidget(FolderWidget(folder: folder));

    await Future.delayed(const Duration(seconds: 1));

    expect(find.text('Cartella1'), findsOneWidget);
  });
}
