import 'package:dish_delight/authentication/loginPage.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isLoading = true;
  void loadToHome() async{
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadToHome();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 300,),


            FadeInImage(

              placeholder : AssetImage("assets/icons/logo.png"),
              image: AssetImage("assets/icons/logo.png") ,

              height: 230 , width: 230,),

            Spacer(),
            // Text("Developed By\nANANTA" ,textAlign: TextAlign.center ,style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
            // SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}
