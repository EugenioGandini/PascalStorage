import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/resource_provider.dart';
import '../../../models/models.dart';

class DialogShareResource extends StatefulWidget {
  final Resource resource;

  const DialogShareResource({
    super.key,
    required this.resource,
  });

  @override
  State<DialogShareResource> createState() => _DialogShareResourceState();
}

class _DialogShareResourceState extends State<DialogShareResource> {
  final _formKey = GlobalKey<FormState>();
  ShareConfiguration _configuration =
      ShareConfiguration(quantity: 1, timeUnit: "hours");

  Future _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    var navigator = Navigator.of(context);
    var resProvider = Provider.of<ResourceProvider>(context, listen: false);

    Share? newShare = await resProvider.createNewShare(
      widget.resource,
      _configuration,
    );

    if (newShare != null) {
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
          // TextFormField(
          //   decoration: InputDecoration(
          //     icon: const Icon(Icons.text_fields),
          //     labelText: AppLocalizations.of(context)!.newName,
          //   ),
          //   textInputAction: TextInputAction.done,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return AppLocalizations.of(context)!.validatorEmptyName;
          //     }

          //     if (!widget.isFolder && !value.contains('.')) {
          //       return AppLocalizations.of(context)!.validatorMissingExtension;
          //     }

          //     return null;
          //   },
          //   onSaved: (newName) {
          //     _name = newName!;
          //   },
          // ),
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

Future buildDialogNewShare(
  BuildContext context,
  Resource resourceToShare,
) async {
  var isFolder = resourceToShare is ResourceFolder;

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
                    ? AppLocalizations.of(context)!
                        .dialogTitleShareResourceFolder
                    : AppLocalizations.of(context)!
                        .dialogTitleShareResourceFile,
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
        content: DialogShareResource(
          resource: resourceToShare,
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
