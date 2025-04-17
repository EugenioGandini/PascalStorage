import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';

class DialogRemoveShares extends StatefulWidget {
  final List<Share> shares;

  const DialogRemoveShares({
    super.key,
    required this.shares,
  });

  @override
  State<DialogRemoveShares> createState() => _DialogRemoveSharesState();
}

class _DialogRemoveSharesState extends State<DialogRemoveShares> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future buildDialogRemoveShare(
  BuildContext context,
  Resource resource,
  List<Share> activeShares,
) async {
  var isFolder = resource is ResourceFolder;

  var createSuccessfully = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                isFolder
                    ? AppLocalizations.of(context)!.dialogTitleShareActiveFolder
                    : AppLocalizations.of(context)!.dialogTitleShareActiveFile,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, size: 32),
            ),
          ],
        ),
        content: DialogRemoveShares(
          shares: activeShares,
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      );
    },
  );

  if (createSuccessfully is bool && createSuccessfully) {
    return true;
  }
  return false;
}
