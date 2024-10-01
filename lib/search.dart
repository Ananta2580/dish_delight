import 'dart:convert';
import 'dart:developer';
import 'package:dish_delight/model.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http ;
import 'package:http/http.dart';

import 'detailView.dart';

class Search extends StatefulWidget {
  String query;
  Search(this.query, {super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  List reciptCatList = [
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    }
  ];

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
            setState(() {
              isLoading = false;
            });
            log(recipeList.toString());
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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getRecipe(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Color(0xff213A50), Color(0xff071938)])),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Search(searchController.text)));
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
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Search(searchController.text)));
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
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
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
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: const BoxDecoration(
                                              color: Colors.black26,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: Text(
                                            recipeList[index].name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        )),
                                    Positioned(
                                        right: 0,
                                        width: 100,
                                        height: 40,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(Icons
                                                    .local_fire_department_sharp),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  recipeList[index]
                                                      .calorie
                                                      .toString()
                                                      .substring(
                                                          0,
                                                          recipeList[index]
                                                                      .calorie
                                                                      .toString()
                                                                      .length <
                                                                  6
                                                              ? recipeList[
                                                                      index]
                                                                  .calorie
                                                                  .toString()
                                                                  .length
                                                              : 6),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
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
