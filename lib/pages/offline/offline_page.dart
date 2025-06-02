import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';

import 'scaffold_page.dart';
import '../../providers/resource_provider.dart';
import '../../utils/logger.dart';
import '../../models/models.dart';

import '../../widgets/widgets.dart';
import 'widgets/empty_offline_content.dart';

class OfflinePage extends StatefulWidget {
  static const String routeName = '/offlinePage';

  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  final Logger _logger = const Logger('OfflinePage');

  late Future _futureLoadSync;
  Sync? _sync;

  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_init) return;

    var resProvider = Provider.of<ResourceProvider>(context, listen: false);

    _futureLoadSync = resProvider.loadSync();

    _init = true;
  }

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

                setState(() {
                  _futureLoadSync = resProvider.loadSync();
                });
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

  void _filterElementsByKeyword(String? keyword) {
    if (_sync == null) return;

    setState(() {
      _sync!.applyFilter(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      onForceSync: () => _forceSync(context),
      onFilterElements: _filterElementsByKeyword,
      body: FutureBuilder(
        future: _futureLoadSync,
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

          _sync = sync;

          _logger.message('Loaded sync ${sync.name} - ID ${_sync!.id}');

          var offlineFilesLoaded = _sync!.offlineFiles;

          if (offlineFilesLoaded.isEmpty) {
            return const EmptyOfflineContent();
          }

          return SyncContentWidget(
            syncContent: _sync!,
            onFileTap: _openOfflineFile,
            onFileLongPress: (offlineCopy) =>
                _openFileDetails(context, offlineCopy),
          );
        },
      ),
    );
  }
}
