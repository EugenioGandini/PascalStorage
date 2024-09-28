import 'package:flutter/material.dart';

import './login_form.dart';
import '../my_storage/my_storage_page.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  void navigareToMyStorage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(MyStoragePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 300,
        child: LoginForm(
          onLoggedIn: () => navigareToMyStorage(context),
        ),
      ),
    );
  }
}
