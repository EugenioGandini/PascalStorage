import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/resource_provider.dart';

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

  Future _submitRemoveShares() async {
    var navigator = Navigator.of(context);

    var resourceProvider =
        Provider.of<ResourceProvider>(context, listen: false);

    await Future.forEach(_sharesSelected, (share) async {
      return await resourceProvider.deleteShare(share);
    });

    navigator.pop(true);
  }

  Widget _buildTileShare(Share share) {
    var selected = _sharesSelected.contains(share);

    var expiration = DateFormat.yMMMd().add_jm().format(share.expire);

    return CheckboxListTile(
      secondary: const Icon(Icons.share),
      title: Text(AppLocalizations.of(context)!.expiresAt(expiration)),
      subtitle: Text('Hash ${share.hash}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                ...widget.shares.map((share) {
                  return _buildTileShare(share);
                }),
              ],
            ),
          ),
        ),
        const Divider(
          height: 36,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _submitRemoveShares,
            child: Text(
              AppLocalizations.of(context)!.removeShare(_sharesSelected.length),
            ),
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

  var removedShares = await showDialog(
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

  if (removedShares is bool && removedShares) {
    return true;
  }
  return false;
}
