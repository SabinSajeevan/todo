import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/helpers/response_state.dart';
part 'register_notifier.g.dart';

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  ResponseState build() {
    return (ResponseState(isLoading: false, isError: false));
  }

  Future<void> getRegister({required Map body}) async {
    try {
      state = state.copyWith(isLoading: true, head: "register", isError: false);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: body['email'],
        password: body['password'],
      );
      state = state.copyWith(
          isLoading: false, head: "register", isError: false, response: true);
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      state = state.copyWith(
          isLoading: false,
          head: "register",
          isError: true,
          errorMessage: message);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "register",
          isError: true,
          errorMessage: e.toString());
    }
  }
}
