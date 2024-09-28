import 'package:flutter_test/flutter_test.dart';

import 'package:filebrowser/models/folder.dart';
import 'package:filebrowser/pages/my_storage/folder_widget.dart';

void main() {
  testWidgets('Show folder sample widget', (tester) async {
    Folder folder = Folder(
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
