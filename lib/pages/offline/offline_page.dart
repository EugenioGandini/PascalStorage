import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/resource_provider.dart';
import '../../utils/logger.dart';
import '../../models/models.dart';

import '../base_page.dart';
import '../../widgets/widgets.dart';
import 'widgets/empty_offline_content.dart';

class OfflinePage extends StatelessWidget {
  final Logger _logger = const Logger('OfflinePage');

  static const String routeName = '/offlinePage';

  const OfflinePage({super.key});

  void _openOfflineFile(OfflineFile file) {
    var filePath = file.localCopy.path;

    OpenFile.open(filePath);
  }

  void _openFileDetails(BuildContext context, OfflineFile file) {
    var resProvider = Provider.of<ResourceProvider>(context, listen: false);

    var localCopy = file.localCopy;

    _logger.message('User opened file ${localCopy.name}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: FileDetails(
              fileName: localCopy.name,
              fileExtension: localCopy.extension,
              fileModified: localCopy.modified,
              fileSize: localCopy.size,
              onDelete: () {
                Navigator.of(context).pop();

                resProvider.deleteOfflineFiles([file]);
              },
              isSynchronized: file.synchronize,
              toggleSync: () {
                Navigator.of(context).pop();

                var updatedOfflineFile =
                    file.copyWith(synchronize: !file.synchronize);

                resProvider.updateOfflineFiles(updatedOfflineFile);
              },
            ),
          ),
        );
      },
    );
  }

  void _forceSync(BuildContext context) {
    var resProvider = Provider.of<ResourceProvider>(context, listen: false);

    _logger.message('Forcing sync of all files');

    resProvider.syncFiles();
  }

  @override
  Widget build(BuildContext context) {
    var resProvider = Provider.of<ResourceProvider>(context);

    return BasePage(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleOfflinePage),
        actions: [
          IconButton(
            onPressed: () => _forceSync(context),
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      drawer: const AppNavigator(currentRoute: OfflinePage.routeName),
      body: FutureBuilder(
        future: resProvider.loadSync(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var sync = snapshot.data;

          if (sync == null) {
            return const FailLoadContent();
          }

          _logger.message('Loaded sync ${sync.name} - ID ${sync.id}');

          var offlineFilesLoaded = sync.offlineFiles;

          if (offlineFilesLoaded.isEmpty) {
            return const EmptyOfflineContent();
          }

          return SyncContentWidget(
            syncContent: sync,
            onFileTap: _openOfflineFile,
            onFileLongPress: (offlineCopy) =>
                _openFileDetails(context, offlineCopy),
          );
        },
      ),
    );
  }
}
