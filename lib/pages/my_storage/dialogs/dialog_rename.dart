import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../providers/resource_provider.dart';

class DialogRename extends StatefulWidget {
  final RemoteFolder? folder;
  final RemoteFile? file;

  const DialogRename({
    super.key,
    this.file, // accept or the file
    this.folder, // accept or the folder
  });

  @override
  State<DialogRename> createState() => _DialogRenameState();
}

class _DialogRenameState extends State<DialogRename> {
  final _formKey = GlobalKey<FormState>();
  final _newNameController = TextEditingController();
  String _newName = "";
  bool _fullName = false;

  bool get isForAFile {
    return widget.file != null;
  }

  @override
  void initState() {
    super.initState();

    _fullName = false;
    _newName =
        isForAFile ? widget.file!.nameWithoutExtension : widget.folder!.name;
    _newNameController.text = _newName;
  }

  void _toggleFullName() {
    setState(() {
      _fullName = !_fullName;

      if (_fullName) {
        _newName = widget.file!.name;
      } else {
        _newName = widget.file!.nameWithoutExtension;
      }

      _newNameController.text = _newName;
    });
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    var navigator = Navigator.of(context);
    var resProvider = Provider.of<ResourceProvider>(context, listen: false);

    String finalName = _newName;
    if (!_fullName && isForAFile) {
      var extension = widget.file!.extension;

      finalName = "$finalName.$extension";
    }

    bool success = isForAFile
        ? await resProvider.renameFile(widget.file!, finalName)
        : await resProvider.renameFolder(widget.folder!, finalName);

    if (success) {
      navigator.pop(true);
    }
  }

  @override
  void dispose() {
    _newNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isForAFile) ...[
            Row(
              children: [
                Expanded(
                    child: Text(
                  AppLocalizations.of(context)!.fullName,
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
                Checkbox(value: _fullName, onChanged: (_) => _toggleFullName()),
              ],
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.text_fields),
              labelText: AppLocalizations.of(context)!.newName,
            ),
            controller: _newNameController,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorEmptyName;
              }

              var name = isForAFile
                  ? widget.file!.nameWithoutExtension
                  : widget.folder!.name;

              if (value == name) {
                return AppLocalizations.of(context)!.validatorSameName;
              }

              return null;
            },
            onSaved: (newName) {
              _newName = newName!;
            },
          ),
          const Divider(
            height: 36,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _submit,
              child: Text(AppLocalizations.of(context)!.rename),
            ),
          ),
        ],
      ),
    );
  }
}

Future buildDialogRenameResource(
  BuildContext context, {
  RemoteFile? fileToBeRenamed,
  RemoteFolder? folderToBeRenamed,
}) async {
  var renameSuccessfully = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(AppLocalizations.of(context)!.dialogTitleRename),
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
        content: DialogRename(
          file: fileToBeRenamed,
          folder: folderToBeRenamed,
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      );
    },
  );

  if (renameSuccessfully is bool && renameSuccessfully) {
    return true;
  }
  return false;
}
