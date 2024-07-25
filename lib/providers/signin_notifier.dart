import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/helpers/response_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'signin_notifier.g.dart';

@riverpod
class SignInNotifier extends _$SignInNotifier {
  @override
  ResponseState build() {
    return (ResponseState(isLoading: false, isError: false));
  }

  Future<void> getSignIn({required Map body}) async {
    try {
      state = state.copyWith(isLoading: true, head: "signin", isError: false);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: body['email'],
        password: body['password'],
      );
      state = state.copyWith(
          isLoading: false, head: "signin", isError: false, response: true);
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        message = 'Invalid login credentials.';
      } else {
        message = e.code;
      }
      state = state.copyWith(
          isLoading: false,
          head: "signin",
          isError: true,
          errorMessage: message);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "signin",
          isError: true,
          errorMessage: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(
          isLoading: true, head: "signinWithGoogle", isError: false);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      state = state.copyWith(
          isLoading: false,
          head: "signinWithGoogle",
          isError: false,
          response: true);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "signinWithGoogle",
          isError: true,
          errorMessage: e.toString());
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          head: "signinWithGoogle",
          isError: true,
          errorMessage: e.toString());
    }
  }
}
