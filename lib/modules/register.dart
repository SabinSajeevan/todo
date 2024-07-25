import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/constants/route_path.dart';
import 'package:todo/helpers/common_helpers.dart';
import 'package:todo/helpers/response_state.dart';
import 'package:todo/helpers/widgets/common_appbar.dart';
import 'package:todo/helpers/widgets/common_button.dart';
import 'package:todo/helpers/widgets/common_textfield.dart';
import 'package:todo/providers/register_notifier.dart';

class Register extends ConsumerWidget {
  Register({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  onPressed(
      {required String type, required WidgetRef ref, BuildContext? context}) {
    if (type == "Register") {
      if (_formKey.currentState!.validate()) {
        if (passwordController.text == confirmPasswordController.text) {
          Map register = {
            "email": usernameController.text,
            "password": passwordController.text,
          };

          FocusManager.instance.primaryFocus?.unfocus();

          ref
              .read(registerNotifierProvider.notifier)
              .getRegister(body: register);
        } else {
          showMessage(context!, "Passwords mismatch!", type: "error");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ResponseState>(registerNotifierProvider,
        (ResponseState? previous, ResponseState next) {
      if (next.head == "register") {
        if (next.isLoading!) {
          showProgress(context);
        } else if (next.isError! && !next.isLoading!) {
          Navigator.pop(context);
          showMessage(context, next.errorMessage!);
        } else {
          if (next.response == true) {
            showMessage(context, "Register success!", type: "success");
            Navigator.pushReplacementNamed(context, homeScreen);
          }
          Navigator.pop(context);
        }
      }
    });
    return Scaffold(
      appBar: const CommonAppBar(title: ""),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 100,
                ),
                CommonTextField(
                    label: "Email",
                    controller: usernameController,
                    hintText: "Email",
                    isEmail: true,
                    onChanged: (val) {}),
                CommonTextField(
                    label: "Password",
                    hintText: "Password",
                    hasTrailing: true,
                    isTrailingObscure: true,
                    controller: passwordController,
                    onChanged: (val) {}),
                const SizedBox(
                  height: 10,
                ),
                CommonTextField(
                    label: "Confirm Password",
                    hintText: "Confirm Password",
                    hasTrailing: true,
                    isTrailingObscure: true,
                    controller: confirmPasswordController,
                    onChanged: (val) {}),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonButton(
                      horizontalPadding: 60,
                      onButtonPressed: () {
                        onPressed(type: "Register", ref: ref, context: context);
                      },
                      label: "Register",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
