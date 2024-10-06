import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/colors.dart';
import '../base_page.dart';
import './login_form.dart';
import '../my_storage/my_storage_page.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  void _goToMyStorage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(MyStoragePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: Center(
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                offset: Offset(10, 10),
                blurRadius: 20,
              )
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24,
                ),
                child: Text(
                  AppLocalizations.of(context)!.titleSignIn,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              LoginForm(
                onLoggedInSuccessfully: () => _goToMyStorage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
