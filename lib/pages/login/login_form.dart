import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';

import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

import 'notifications.dart' as notify;

class LoginForm extends StatefulWidget {
  final VoidCallback onLoggedInSuccessfully;

  const LoginForm({
    super.key,
    required this.onLoggedInSuccessfully,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _keyForm = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  String _host = "";
  bool _logginIn = false;
  bool _saveCredentials = false;

  @override
  void initState() {
    super.initState();

    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    var settings = settingsProvider.settings;

    _host = settings.host;

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.hasSavedCredentials) {
      var credentials = authProvider.savedCredentials;

      setState(() {
        _username = credentials.username;
        _password = credentials.password;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          _submit();
        }
      });
    }
  }

  Future _submit() async {
    if (!_keyForm.currentState!.validate()) return;

    _keyForm.currentState!.save();

    setState(() {
      _logginIn = true;
    });

    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    User user = User(username: _username, password: _password);

    await settingsProvider.saveHost(_host);

    bool loggedIn = await authProvider.login(user);

    if (loggedIn) {
      if (_saveCredentials) {
        await authProvider.saveCredentials(user);
      }

      if (mounted) {
        notify.showSuccessLogin(context);
      }

      widget.onLoggedInSuccessfully();
    } else {
      if (mounted) {
        notify.showErrorLogin(context);
      }
    }

    setState(() {
      _logginIn = false;
    });
  }

  Widget _showProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.http),
              labelText: AppLocalizations.of(context)!.host,
            ),
            enabled: !_logginIn,
            textInputAction: TextInputAction.next,
            initialValue: _host,
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
            onSaved: (host) {
              _host = host!;
            },
          ),
          const Divider(
            height: 46,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              labelText: AppLocalizations.of(context)!.username,
            ),
            initialValue: _username,
            enabled: !_logginIn,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorEmptyUsername;
              }

              return null;
            },
            onSaved: (usernameEntered) {
              _username = usernameEntered!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.password),
              labelText: AppLocalizations.of(context)!.password,
            ),
            initialValue: _password,
            enabled: !_logginIn,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.validatorEmptyPassword;
              }

              return null;
            },
            onSaved: (passwordEntered) {
              _password = passwordEntered!;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.saveCredentials),
              Checkbox(
                value: _saveCredentials,
                onChanged: (value) {
                  setState(() {
                    _saveCredentials = value!;
                  });
                },
              )
            ],
          ),
          _logginIn
              ? _showProgressIndicator()
              : const SizedBox(
                  height: 32,
                ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logginIn ? null : _submit,
              label: Text(AppLocalizations.of(context)!.enter),
              icon: const Icon(Icons.login_outlined),
            ),
          )
        ],
      ),
    );
  }
}
