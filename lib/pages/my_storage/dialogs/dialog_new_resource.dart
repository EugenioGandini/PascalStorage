import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../providers/resource_provider.dart';

class DialogNewResource extends StatefulWidget {
  final bool isFolder;
  final RemoteFolder parentFolder;

  const DialogNewResource({
    super.key,
    required this.parentFolder,
    this.isFolder = true,
  });

  @override
  State<DialogNewResource> createState() => _DialogNewResourceState();
}

class _DialogNewResourceState extends State<DialogNewResource> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";

  Future _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    var navigator = Navigator.of(context);
    var resProvider = Provider.of<ResourceProvider>(context, listen: false);

    bool success = false;

    if (widget.isFolder) {
      RemoteFolder newRemoteFolder = RemoteFolder(
        path: widget.parentFolder.path,
        name: _name,
        size: 0,
        modified: DateTime.now(),
      );

      success = await resProvider.createFolder(newRemoteFolder);
    }

    if (success) {
      navigator.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.text_fields),
              labelText: AppLocalizations.of(context)!.newName,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorEmptyName;
              }

              if (!widget.isFolder && !value.contains('.')) {
                return AppLocalizations.of(context)!.validatorMissingExtension;
              }

              return null;
            },
            onSaved: (newName) {
              _name = newName!;
            },
          ),
          const Divider(
            height: 36,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(AppLocalizations.of(context)!.create),
            ),
          ),
        ],
      ),
    );
  }
}

Future buildDialogNewResource(
  BuildContext context,
  RemoteFolder parentFolder,
  bool isFolder,
) async {
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
                    ? AppLocalizations.of(context)!.dialogTitleNewFolder
                    : AppLocalizations.of(context)!.dialogTitleNewFile,
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
        content: DialogNewResource(
          parentFolder: parentFolder,
          isFolder: isFolder,
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
