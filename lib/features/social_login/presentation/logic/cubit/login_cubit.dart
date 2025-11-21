import 'package:assisment/features/social_login/presentation/logic/cubit/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Same state file as before
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  AuthCubit() : super(AuthInitial());

  // --- GOOGLE SIGN IN ---
Future<void> signInWithGoogle() async {
  try {
    emit(AuthLoading());

    // 1. FORCE SIGN OUT first to clear stale cache
    await _googleSignIn.signOut(); 

    // 2. Now sign in fresh
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      emit(AuthInitial()); 
      return;
    }

    // 3. Get fresh tokens
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _signInWithCredential(credential);
  } catch (e) {
    emit(AuthFailure(_handleError(e)));
  }
}

  // --- FACEBOOK SIGN IN ---
  Future<void> signInWithFacebook() async {
    try {
      emit(AuthLoading());

      // 1. Trigger Native Facebook Login
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // 2. Create Firebase Credential
        final AuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // 3. Sign in to Firebase
        await _signInWithCredential(credential);
      } else if (result.status == LoginStatus.cancelled) {
        emit(AuthInitial());
      } else {
        emit(AuthFailure("Facebook login failed: ${result.message}"));
      }
    } catch (e) {
      emit(AuthFailure(_handleError(e)));
    }
  }

  // Shared Logic to prevent code duplication
  Future<void> _signInWithCredential(AuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        emit(AuthSuccess(userCredential.user!));
      } else {
        emit(AuthFailure("Sign in failed: User is null"));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Authentication Error"));
    }
  }

  String _handleError(dynamic e) {
    return e.toString().replaceAll("Exception:", "").trim();
  }
}
