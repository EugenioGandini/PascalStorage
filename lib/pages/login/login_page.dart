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
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24,
                ),
                child: Text(
                  "Sign-in",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              LoginForm(
                onLoggedIn: () => navigareToMyStorage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
