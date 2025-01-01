import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogNewHost extends StatefulWidget {
  final String host;

  const DialogNewHost({
    super.key,
    this.host = '',
  });

  @override
  State<DialogNewHost> createState() => _DialogNewHostState();
}

class _DialogNewHostState extends State<DialogNewHost> {
  final _formKey = GlobalKey<FormState>();
  String _host = '';

  @override
  void initState() {
    super.initState();
    _host = widget.host;
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    var navigator = Navigator.of(context);

    navigator.pop(_host);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: _host,
            decoration: InputDecoration(
              icon: const Icon(Icons.text_fields),
              labelText: AppLocalizations.of(context)!.host,
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorEmptyHost;
              }
              if (!value.startsWith('http')) {
                return AppLocalizations.of(context)!.validatorStartNameHost;
              }
              if (value.endsWith('/')) {
                return AppLocalizations.of(context)!.validatorEndNameHost;
              }

              return null;
            },
            onSaved: (newHost) {
              _host = newHost!;
            },
          ),
          const Divider(
            height: 36,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> buildDialogNewHost(
  BuildContext context,
  String previousHost,
) async {
  var newHost = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(AppLocalizations.of(context)!.dialogTitleNewHost),
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
        content: DialogNewHost(
          host: previousHost,
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      );
    },
  );

  return newHost as String?;
}
