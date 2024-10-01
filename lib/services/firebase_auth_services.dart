import 'package:firebase_auth/firebase_auth.dart';
import 'package:dish_delight/services/localdb.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dish_delight/services/modelview.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signUpWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      print(user);

      localDataSaver.saveUserName(user!.displayName.toString());
      localDataSaver.saveMail(user.email.toString());
      localDataSaver.saveLoginData(true);

      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      print(user);

      localDataSaver.saveUserName(user!.displayName.toString());
      localDataSaver.saveMail(user.email.toString());
      localDataSaver.saveLoginData(true);

      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final userCredential = await auth.signInWithCredential(authCredential);
      final User? user = userCredential.user;

      assert(!user!.isAnonymous);
      assert(await user?.getIdToken() != null);

      final User? currentuser = auth.currentUser;

      assert(currentuser?.uid == user?.uid);
      print(user);

      localDataSaver.saveUserName(user!.displayName.toString());
      localDataSaver.saveMail(user.email.toString());
      localDataSaver.saveLoginData(true);

      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return null;
  }


  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw FirebaseAuthException(
          code: 'Facebook Login Failed',
          message: 'The Facebook login was not successful.',
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions
      print('Firebase Auth Exception: ${e.message}');
      throw e; // rethrow the exception
    } catch (e) {
      // Handle other exceptions
      print('Other Exception: $e');
      throw e; // rethrow the exception
    }
  }

  Future<String> signOut() async{
    await auth.signOut();
    await googleSignIn.signOut();
    return "Success";

  }
}
