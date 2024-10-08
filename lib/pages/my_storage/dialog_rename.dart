import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';
import '../../providers/resource_provider.dart';

class DialogRename extends StatefulWidget {
  final RemoteFile file;

  const DialogRename({
    super.key,
    required this.file,
  });

  @override
  State<DialogRename> createState() => _DialogRenameState();
}

class _DialogRenameState extends State<DialogRename> {
  final _formKey = GlobalKey<FormState>();
  final _newNameController = TextEditingController();
  String _newName = "";
  bool _fullName = false;

  @override
  void initState() {
    super.initState();

    _fullName = false;
    _newName = widget.file.nameWithoutExtension;
    _newNameController.text = _newName;
  }

  void _toggleFullName() {
    setState(() {
      _fullName = !_fullName;

      if (_fullName) {
        _newName = widget.file.name;
      } else {
        _newName = widget.file.nameWithoutExtension;
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
    if (!_fullName) {
      finalName = "$finalName.${widget.file.extension}";
    }

    bool success = await resProvider.renameFile(widget.file, finalName);

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
          Row(
            children: [
              Expanded(child: Text(AppLocalizations.of(context)!.fullName)),
              Checkbox(value: _fullName, onChanged: (_) => _toggleFullName()),
            ],
          ),
          const SizedBox(height: 16),
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
              if (value == widget.file.nameWithoutExtension) {
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
            child: ElevatedButton(
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
    BuildContext context, RemoteFile fileToBeRenamed) async {
  var renameSuccessfully = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(AppLocalizations.of(context)!.dialogTitleRename),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        content: DialogRename(
          file: fileToBeRenamed,
        ),
      );
    },
  );

  if (renameSuccessfully is bool && renameSuccessfully) {
    return true;
  }
  return false;
}
