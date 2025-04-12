import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../utils/files_utils.dart';
import '../../../config/colors.dart';

class ShareItem extends StatelessWidget {
  final Share share;
  final VoidCallback onTap;

  const ShareItem({
    super.key,
    required this.share,
    required this.onTap,
  });

  Color _getSplashColor() {
    var color = share.isFolder
        ? AppColors.deepBlue
        : getFileForegroundColor(share.extension);

    return color.withAlpha(120);
  }

  @override
  Widget build(BuildContext context) {
    var isFolder = share.isFolder;
    var fileExtension = isFolder ? '' : share.extension;
    var name = share.name;
    var hash = share.hash;
    var expiration = DateFormat.yMMMd().add_jm().format(share.expire);

    return Card(
      color: isFolder ? Colors.white : getFileBackgroundColor(fileExtension),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: _getSplashColor(),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: SizedBox(
            width: 48,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    isFolder ? Icons.folder : getFileIcon(fileExtension),
                    color: getFileForegroundColor(fileExtension),
                    size: 40,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2, left: 2, right: 4),
                    decoration: BoxDecoration(
                      color: AppColors.deepBlue,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                    ),
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: getFileForegroundColor(fileExtension),
            ),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.expiresAt(expiration),
            style: TextStyle(
              fontSize: 12,
              color: getFileForegroundColor(fileExtension),
            ),
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Hash'),
              Text('($hash)'),
            ],
          ),
        ),
      ),
    );
  }
}
