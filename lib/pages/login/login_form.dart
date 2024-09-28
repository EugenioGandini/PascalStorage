import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filebrowser/models/models.dart';

import 'package:filebrowser/providers/auth_provider.dart';
import 'package:filebrowser/providers/settings_provider.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onLoggedIn;

  const LoginForm({
    super.key,
    required this.onLoggedIn,
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
    }
  }

  Future<void> _submit(BuildContext context) async {
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

      widget.onLoggedIn();
    } else {
      // TODO show error login
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
            decoration: const InputDecoration(
              icon: Icon(Icons.http),
              labelText: "Host",
            ),
            enabled: !_logginIn,
            textInputAction: TextInputAction.next,
            initialValue: _host,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Your host (e.g.: https://example.com:3000)';
              }
              if (!value.startsWith('http')) {
                return 'Host must start with https or http';
              }
              if (value.endsWith('/')) {
                return 'Host must end without \'/\'';
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
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: "Username",
            ),
            initialValue: _username,
            enabled: !_logginIn,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }

              return null;
            },
            onSaved: (usernameEntered) {
              _username = usernameEntered!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.password),
              labelText: "Password",
            ),
            initialValue: _password,
            enabled: !_logginIn,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }

              return null;
            },
            onSaved: (passwordEntered) {
              _password = passwordEntered!;
            },
            onFieldSubmitted: (_) => _submit(context),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Save credentials'),
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
              onPressed: _logginIn ? null : () => _submit(context),
              label: const Text("Enter"),
              icon: const Icon(Icons.login_outlined),
            ),
          )
        ],
      ),
    );
  }
}
