import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _info = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.footerAuthor,
        ),
        if (_info != null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text("Pascal Storage™"),
          ),
        if (_info != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              AppLocalizations.of(context)!.footerAppVersion(_info!.version),
            ),
          ),
      ],
    );
  }
}
