import 'package:dish_delight/authentication/loginPage.dart';
import 'package:dish_delight/home.dart';
import 'package:dish_delight/services/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/constant.dart';
import 'package:dish_delight/services/localdb.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, Key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoadingUp = false;
  final FirebaseAuthService auth = FirebaseAuthService();

  TextEditingController usercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void dispose() {
    usercontroller.dispose();
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
                      "SignUp",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // UserName TextField
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: TextField(
                      controller: usercontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "userName123",
                        labelText: "UserName",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                        labelText: "PassWord",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SignUp Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: signUp,
                      child: isLoadingUp ? CircularProgressIndicator() : const Text("SignUp"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SignIn Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an Account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: const Text("SignIn here."),
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
  void signUp() async{

    setState(() {
      isLoadingUp = true;
    });
    String userName = usercontroller.text;
    String eMail = emailcontroller.text;
    String passWord = passwordcontroller.text;

    User? user = await auth.signUpWithEmailandPassword(eMail, passWord);

    Constant.mail = (await localDataSaver.getMail())!;
    Constant.name = (await localDataSaver.getUserName())!;


    setState(() {
      isLoadingUp = false;
    });

    if(user != null){
      print("Successfully created");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    }
    else{
      print("Not Created");
    }

  }
}

