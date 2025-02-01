import 'package:flutter_test/flutter_test.dart';
import 'package:pascalstorage/models/models.dart';

import 'package:pascalstorage/pages/my_storage/widgets/folder_widget.dart';

void main() {
  testWidgets('Show folder sample widget', (tester) async {
    ResourceFolder folder = ResourceFolder(
      name: 'Cartella1',
      path: '/Home/Folder/Subfolder',
      size: 0,
      modified: DateTime.now(),
    );

    await tester.pumpWidget(FolderWidget(
      folderName: folder.name,
    ));

    await Future.delayed(const Duration(seconds: 1));

    expect(find.text('Cartella1'), findsOneWidget);
  });
}
