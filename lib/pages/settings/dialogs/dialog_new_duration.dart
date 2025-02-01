import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogNewDuration extends StatefulWidget {
  final Duration duration;

  const DialogNewDuration({
    super.key,
    this.duration = Duration.zero,
  });

  @override
  State<DialogNewDuration> createState() => _DialogNewDurationState();
}

class _DialogNewDurationState extends State<DialogNewDuration> {
  final _formKey = GlobalKey<FormState>();
  int _durationSeconds = 0;

  @override
  void initState() {
    super.initState();
    _durationSeconds = widget.duration.inSeconds;
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    var navigator = Navigator.of(context);

    navigator.pop(Duration(seconds: _durationSeconds));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              icon: const Icon(Icons.timer_outlined),
              labelText: AppLocalizations.of(context)!.frequencySeconds,
            ),
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isEmpty) {
                _durationSeconds = 0;
                return;
              }

              _durationSeconds = int.parse(value);
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

Future<Duration?> buildDialogNewDuration(
  BuildContext context,
  Duration previousDuration,
) async {
  var newDuration = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  Text(AppLocalizations.of(context)!.dialogTitleNewFrequency),
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
        content: DialogNewDuration(
          duration: previousDuration,
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      );
    },
  );

  return newDuration as Duration?;
}
