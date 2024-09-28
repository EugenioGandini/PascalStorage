import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filebrowser/models/models.dart';

import 'package:filebrowser/providers/auth_provider.dart';

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

  Future<void> _submit(BuildContext context) async {
    if (!_keyForm.currentState!.validate()) return;

    _keyForm.currentState!.save();

    User user = User(username: _username, password: _password);

    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool loggedIn = await authProvider.login(user);

    if (loggedIn) {
      widget.onLoggedIn();
    }
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
              icon: Icon(Icons.person),
              labelText: "Username",
            ),
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
          ),
          ElevatedButton.icon(
            onPressed: () => _submit(context),
            label: const Text("Enter"),
            icon: const Icon(Icons.login_outlined),
          )
        ],
      ),
    );
  }
}
