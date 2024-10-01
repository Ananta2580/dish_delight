import 'dart:convert';
import 'dart:math';
import 'package:dish_delight/authentication/loginPage.dart';
import 'package:dish_delight/detailView.dart';
import 'package:dish_delight/model.dart';
import 'package:dish_delight/search.dart';
import 'package:dish_delight/services/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http ;
import 'package:http/http.dart';
import 'package:dish_delight/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();
  List reciptCatList = [{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Turkish"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Indian"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chinese"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Italian food"}];

  bool isLoading = true;

  List<RecipeModel> recipeList = <RecipeModel>[];

  //Method for fetching Api.
  getRecipe(String query) async {
    try {
      String url =
          "https://api.edamam.com/search?q=$query&app_id=7402860c&app_key=c704591b0f21b52f1bac394481bf37e1";
      Response response = await get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        //print(data);
        //log(data.toString());

        setState(() {
          data["hits"].forEach((element) {
            RecipeModel recipeModel = RecipeModel();
            recipeModel = RecipeModel.fromMap(element["recipe"]);
            recipeList.add(recipeModel);
            setState((){
              isLoading = false ;
            });
            //log(recipeList.toString());
          });
        });

        for (var Recipe in recipeList) {
          print(Recipe.name);
          print(Recipe.calorie);
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

signOutMethod() async{
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    var foodName = ["rice", "ladoo", "paneer", "fruit","mutton","dal"];
    final random = Random();
    var food = foodName[random.nextInt(foodName.length)];
    getRecipe(food);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xff213A50), Color(0xff071938)])
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xff213A50), Color(0xff071938)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Constant.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    Constant.mail,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('SignOut'),
              onTap: () {
                signOutMethod();

              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle item 2
              },
            ),
            // Add more ListTiles for additional items
          ],
        ),
      ),

      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Color(0xff213A50), Color(0xff071938)]),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                         vertical: 10,horizontal: 24),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Search(searchController.text)));
                            }
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                print("Input is empty");
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Search(searchController.text)));
                              }
                            },
                            controller: searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter food you want to cook",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHAT DO YOU WANT TO COOK TODAY ?",
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "let's Cook Something!",
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Horizontal scrollbar wala container
                const SizedBox(height: 30,),
                SizedBox(
                  height: 150,
                  child: ListView.builder( itemCount: reciptCatList.length, shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){

                        return Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Search(reciptCatList[index]["heading"])));
                              },
                              child: Card(
                                  margin: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0.0,
                                  child:Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(20.0),
                                          child: Image.network(reciptCatList[index]["imgUrl"], fit: BoxFit.cover,
                                            width: 200,
                                            height: 250,)
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(20),
                                                    topLeft: Radius.circular(20),
                                                    bottomRight: Radius.circular(20),
                                                    bottomLeft: Radius.circular(20),
                                                  )
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    reciptCatList[index]["heading"],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  )
                              ),
                            )
                        );
                      }),
                ),

                Container(
                  child: isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailView(recipeList[index].appurl)));
                          },
                          child: Card(
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            elevation: 0.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius : BorderRadius.circular(20),
                                  child: Image.network(
                                      recipeList[index].imgUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),

                                Positioned(
                                  left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                      decoration: const BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)
                                        )
                                      ),
                                        child: Text(recipeList[index].name,style: const TextStyle(color: Colors.white,fontSize: 18),),
                                    )
                                ),
                                Positioned(
                                  right: 0,
                                    width: 100,
                                    height: 40,
                                    child: Container(
                                        decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)                                        )
                                      ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(width: 10,),
                                              const Icon(Icons.local_fire_department_sharp),
                                              const SizedBox(width: 10,),
                                              Text(
                                                recipeList[index].calorie.toString().substring(0,
                                                    recipeList[index].calorie.toString().length < 6
                                                        ? recipeList[index].calorie.toString().length
                                                        : 6),
                                              ),
                                            ],
                                          ),
                                        ),

                                    )
                                )
                              ],
                            ),
                          ),
                        );

                      }),
                ),



              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget anuWid() {
  return const Text("Fuck");
}
