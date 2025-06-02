import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers/resource_provider.dart';

import '../../../config/colors.dart';
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
  final _controllerQuantity = TextEditingController(text: '1');

  ShareConfiguration _configuration =
      ShareConfiguration(quantity: 1, timeUnit: TimeUnit.hours);

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
      navigator.pop(newShare);
    }
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.quantityTimeErrorEmpty;
    }

    if (int.tryParse(value) == null) {
      return AppLocalizations.of(context)!.quantityTimeNotNumber;
    }

    return null;
  }

  void _setPreconfiguredTime(int quantity, TimeUnit unit) {
    setState(() {
      _configuration = _configuration.copyWith(
        quantity: quantity,
        timeUnit: unit,
      );
      _controllerQuantity.text = _configuration.quantity.toString();
    });
  }

  void _updateQuantity(int quantity) {
    setState(() {
      _configuration = _configuration.copyWith(quantity: quantity);
    });
  }

  void _updateTimeUnit(TimeUnit? unit) {
    if (unit == null) return;

    setState(() {
      _configuration = _configuration.copyWith(timeUnit: unit);
    });
  }

  void _addPassword(String? password) {
    setState(() {
      if (password == null || password.isEmpty) {
        _configuration = _configuration.copyWith(password: null);
      } else {
        _configuration = _configuration.copyWith(password: password);
      }
    });
  }

  @override
  void dispose() {
    _controllerQuantity.dispose();
    super.dispose();
  }

  List<Widget> _buildQuickOptionButtons() {
    var preSelectedButtonTextStyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: AppColors.deepBlue, fontWeight: FontWeight.bold);

    return [
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(5, TimeUnit.minutes),
        child: Text(
          '5 ${AppLocalizations.of(context)!.minutes}',
          overflow: TextOverflow.ellipsis,
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(30, TimeUnit.minutes),
        child: Text(
          '30 ${AppLocalizations.of(context)!.minutes}',
          overflow: TextOverflow.ellipsis,
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(1, TimeUnit.hours),
        child: Text(
          '1 ${AppLocalizations.of(context)!.hour}',
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(12, TimeUnit.hours),
        child: Text(
          '12 ${AppLocalizations.of(context)!.hours}',
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(1, TimeUnit.days),
        child: Text(
          '1 ${AppLocalizations.of(context)!.day}',
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(7, TimeUnit.days),
        child: Text(
          '1 ${AppLocalizations.of(context)!.week}',
          overflow: TextOverflow.ellipsis,
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(1, TimeUnit.months),
        child: Text(
          '1 ${AppLocalizations.of(context)!.month}',
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(2, TimeUnit.months),
        child: Text(
          '2 ${AppLocalizations.of(context)!.months}',
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(6, TimeUnit.months),
        child: Text(
          '6 ${AppLocalizations.of(context)!.months}',
          style: preSelectedButtonTextStyle,
        ),
      ),
      ElevatedButton(
        onPressed: () => _setPreconfiguredTime(1, TimeUnit.years),
        child: Text(
          '1 ${AppLocalizations.of(context)!.year}',
          style: preSelectedButtonTextStyle,
        ),
      ),
    ];
  }

  Widget _buildManualConfiguration() {
    return Container(
      width: 440,
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controllerQuantity,
              decoration: InputDecoration(
                icon: const Icon(Icons.timelapse_rounded),
                labelText: AppLocalizations.of(context)!.quantityTime,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: _validateQuantity,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (quantity) {
                if (_validateQuantity(quantity) != null) return;

                _updateQuantity(int.parse(quantity));
              },
            ),
          ),
          SizedBox(
            width: 120,
            child: DropdownButtonFormField(
              items: [
                DropdownMenuItem<TimeUnit>(
                  value: TimeUnit.seconds,
                  child: Text(_configuration.quantity == 1
                      ? AppLocalizations.of(context)!.second
                      : AppLocalizations.of(context)!.seconds),
                ),
                DropdownMenuItem<TimeUnit>(
                  value: TimeUnit.minutes,
                  child: Text(_configuration.quantity == 1
                      ? AppLocalizations.of(context)!.minute
                      : AppLocalizations.of(context)!.minutes),
                ),
                DropdownMenuItem<TimeUnit>(
                  value: TimeUnit.hours,
                  child: Text(_configuration.quantity == 1
                      ? AppLocalizations.of(context)!.hour
                      : AppLocalizations.of(context)!.hours),
                ),
                DropdownMenuItem<TimeUnit>(
                  value: TimeUnit.days,
                  child: Text(_configuration.quantity == 1
                      ? AppLocalizations.of(context)!.day
                      : AppLocalizations.of(context)!.days),
                ),
                DropdownMenuItem<TimeUnit>(
                  value: TimeUnit.months,
                  child: Text(_configuration.quantity == 1
                      ? AppLocalizations.of(context)!.month
                      : AppLocalizations.of(context)!.months),
                ),
                DropdownMenuItem<TimeUnit>(
                  value: TimeUnit.years,
                  child: Text(_configuration.quantity == 1
                      ? AppLocalizations.of(context)!.year
                      : AppLocalizations.of(context)!.years),
                ),
              ],
              value: _configuration.timeUnit,
              onChanged: _updateTimeUnit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      decoration: InputDecoration(
        icon: const Icon(Icons.password_rounded),
        labelText: AppLocalizations.of(context)!.passwordInput,
      ),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      validator: (password) {
        if (password != null &&
            password.isNotEmpty &&
            password.trim().length < 4) {
          return AppLocalizations.of(context)!.passwordInputError;
        }

        return null;
      },
      onSaved: _addPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgetManualConfiguration = _buildManualConfiguration();

    var widgetOptionalPassword = _buildPasswordInput();

    var quickOptionButtons = _buildQuickOptionButtons();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widgetManualConfiguration,
                  widgetOptionalPassword,
                  SizedBox(
                    height: 340,
                    width: 400,
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      primary: false,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: quickOptionButtons,
                    ),
                  ),
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
              onPressed: _submit,
              child: Text(AppLocalizations.of(context)!.share),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Share?> buildDialogNewShare(
  BuildContext context,
  Resource resourceToShare,
) async {
  var isFolder = resourceToShare is ResourceFolder;

  var createdShare = await showDialog(
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

  return createdShare;
}
