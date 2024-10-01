import 'package:dish_delight/authentication/signUpPage.dart';
import 'package:dish_delight/home.dart';
import 'package:dish_delight/services/constant.dart';
import 'package:dish_delight/services/firebase_auth_services.dart';
import 'package:dish_delight/services/localdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, Key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> LoginState() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Constant.mail = (await localDataSaver.getMail())!;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoginState();
  }

  googleSIgnInMethod() async {
    await auth.signInWithGoogle();
    Constant.mail = (await localDataSaver.getMail())!;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  facebookSignInMethod() async {
    await auth.signInWithFacebook();
    Constant.mail = (await localDataSaver.getMail())!;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  bool isLoadingIn = false;
  final FirebaseAuthService auth = FirebaseAuthService();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: const Text(
                      "LogIn",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Email TextField
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: TextField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail),
                        hintText: "xyz123@gmail.com",
                        labelText: "Enter Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Password TextField
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        hintText: "Xyz@123",
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SignInButton(mini: true, Buttons.Facebook,
                              onPressed: () {
                            facebookSignInMethod();
                          }),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SignInButton(
                              mini: true,
                              Buttons.Reddit,
                              onPressed: () {}),
                        ),
                      )
                    ],
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.only(bottom: 20),
                    child: SignInButton(
                        Buttons.GoogleDark,
                        onPressed: () {
                      googleSIgnInMethod();
                    }),
                  ),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: signIn,
                      child: isLoadingIn
                          ? const CircularProgressIndicator()
                          : const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SignUp Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an Account?"),
                      TextButton(
                        onPressed: () {
                          print("Navigating");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: const Text("SignUp here."),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    setState(() {
      isLoadingIn = true;
    });
    String eMail = emailcontroller.text;
    String passWord = passwordcontroller.text;

    User? user = await auth.signInWithEmailandPassword(eMail, passWord);

    Constant.mail = (await localDataSaver.getMail())!;

    setState(() {
      isLoadingIn = false;
    });

    if (user != null) {
      print("Successfully logged in");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      print("Not logged in");
    }
  }
}
