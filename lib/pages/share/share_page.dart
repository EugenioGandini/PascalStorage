import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../utils/logger.dart';
import '../../models/models.dart';
import '../../providers/resource_provider.dart';
import '../../providers/settings_provider.dart';

import '../../widgets/widgets.dart';
import '../page_background.dart';
import 'widgets/no_shares.dart';
import 'widgets/list_share.dart';

import '../my_storage/dialogs/dialog_show_uri.dart';

class SharePage extends StatefulWidget {
  static const String routeName = '/sharePage';

  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final Logger _logger = const Logger('SharePage');

  late ResourceProvider _resProvider;
  late Settings _settings;
  late Future _futureLoadShare;

  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_init) return;

    _resProvider = Provider.of<ResourceProvider>(context, listen: false);
    _settings = Provider.of<SettingsProvider>(context, listen: false).settings;

    _futureLoadShare = _resProvider.getShares();

    _init = true;
  }

  void _forceReloadContent() {
    _logger.message('User request a refresh of the shares');
    setState(() {
      _futureLoadShare = _resProvider.getShares();
    });
  }

  void _showUrlShare(Share share) {
    var host = _settings.host;

    buildDialogUri(
      context,
      title: AppLocalizations.of(context)!.uriShareCreatedTitle,
      uri: '$host/share/${share.hash}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleShare),
      ),
      drawer: const AppNavigator(currentRoute: SharePage.routeName),
      body: PageBackground(
        child: RefreshIndicator(
          onRefresh: () {
            _forceReloadContent();
            return _futureLoadShare;
          },
          child: FutureBuilder(
            future: _futureLoadShare,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data;

              if (data == null) {
                return const FailLoadContent();
              }

              var shares = (data as List<Share>);

              if (shares.isEmpty) {
                return const NoShares();
              }

              return ListShare(
                shares: shares,
                onTap: _showUrlShare,
              );
            },
          ),
        ),
      ),
    );
  }
}
