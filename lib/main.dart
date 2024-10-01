import 'package:dish_delight/authentication/loginPage.dart';
import 'package:dish_delight/authentication/signUpPage.dart';
import 'package:dish_delight/firebase_options.dart';
import 'package:dish_delight/home.dart';
import 'package:dish_delight/loading.dart';
import 'package:dish_delight/services/localdb.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoggedIn = false;

  checkLoggedInStatus() async{

    await localDataSaver.getLoginData().then((value) {
      setState(() {
        isLoggedIn = value!;
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     checkLoggedInStatus();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Anu",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? Home() : LoginPage(),
    );
  }
}

