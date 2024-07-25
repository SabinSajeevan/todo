import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/constants/color_path.dart';
import 'package:todo/constants/route_path.dart';
import 'package:todo/helpers/common_helpers.dart';
import 'package:todo/helpers/response_state.dart';
import 'package:todo/helpers/widgets/common_button.dart';
import 'package:todo/helpers/widgets/common_textfield.dart';
import 'package:todo/providers/signin_notifier.dart';

class SignIn extends ConsumerWidget {
  SignIn({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  onPressed(
      {required String type, required WidgetRef ref, BuildContext? context}) {
    if (type == "SignIn") {
      if (_formKey.currentState!.validate()) {
        Map signIn = {
          "email": usernameController.text,
          "password": passwordController.text,
        };
        FocusManager.instance.primaryFocus?.unfocus();

        ref.read(signInNotifierProvider.notifier).getSignIn(body: signIn);
      }
    } else if (type == "signInWithGoogle") {
      ref.read(signInNotifierProvider.notifier).signInWithGoogle();
    } else if (type == "register") {
      Navigator.pushNamed(context!, registerScreen);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    ref.listen<ResponseState>(signInNotifierProvider,
        (ResponseState? previous, ResponseState next) {
      if (next.head == "signin" || next.head == "signinWithGoogle") {
        if (next.isLoading!) {
          showProgress(context);
        } else if (next.isError! && !next.isLoading!) {
          Navigator.pop(context);
          showMessage(context, next.errorMessage!);
        } else {
          if (next.response == true) {
            showMessage(context, "SignIn success!", type: "success");
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, homeScreen);
          } else {
            Navigator.pop(context);
          }
        }
      }
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 60,
              ),
              Container(
                height: screenHeight * 0.25,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: TodoColors.lightWhiteColor,
                    borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: screenWidth * 0.3,
                  width: screenWidth * 0.3,
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CommonButton(
                  onButtonPressed: () {
                    onPressed(type: "signInWithGoogle", ref: ref);
                  },
                  hasIcon: true,
                  verticalPadding: 5,
                  padding: 5,
                  backgroundColor: TodoColors.lightGreyAlternativeColor,
                  labelWithIcon: Row(
                    children: [
                      Image.asset(
                        "assets/images/g-logo.png",
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Sign in with Google",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: TodoColors.secondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "OR",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: TodoColors.lightWhiteAlternativeColor),
                ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "No account?",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: TodoColors.lightWhiteAlternativeColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      onPressed: () {
                        onPressed(type: "register", ref: ref, context: context);
                      },
                      child: Text(
                        "Register",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: TodoColors.textPrimaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonButton(
                    horizontalPadding: 60,
                    onButtonPressed: () {
                      onPressed(type: "SignIn", ref: ref);
                    },
                    label: "SignIn",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
