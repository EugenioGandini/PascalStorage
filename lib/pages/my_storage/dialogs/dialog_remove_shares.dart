import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pascalstorage/config/colors.dart';

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
  final List<Share> _sharesSelected = [];

  void _addShareToRemove(Share share) {
    setState(() {
      _sharesSelected.add(share);
    });
  }

  void _removeShareToRemove(Share share) {
    setState(() {
      _sharesSelected.remove(share);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.shares.map((share) {
          var selected = _sharesSelected.contains(share);

          return CheckboxListTile(
            tileColor: AppColors.lightBlue2,
            title: Text('Expires: ${share.expire.toString()}'),
            subtitle: Text('Hash: ${share.hash}'),
            value: selected,
            onChanged: (bool? checked) {
              if (checked == null) return;

              if (checked) {
                _addShareToRemove(share);
              } else {
                _removeShareToRemove(share);
              }
            },
          );
        }),
        const Divider(
          height: 36,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            child: Text(AppLocalizations.of(context)!
                .removeShare(_sharesSelected.length)),
          ),
        ),
      ],
    );
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
