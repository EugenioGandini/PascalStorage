import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/logger.dart';

import '../../widgets/widgets.dart';
import '../page_background.dart';

class SharePage extends StatelessWidget {
  static const String routeName = '/sharePage';

  const SharePage({super.key});

  final Logger _logger = const Logger('SharePage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleShare),
      ),
      drawer: const AppNavigator(currentRoute: SharePage.routeName),
      body: PageBackground(
        child: Placeholder(),
      ),
    );
  }
}
