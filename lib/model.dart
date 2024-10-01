class RecipeModel{
  //label = Name of the Recipe
   late String name;
   late String imgUrl;
   late double calorie;
   late String appurl;

   RecipeModel({this.name="Label",this.imgUrl="Image",this.calorie=0.00,this.appurl="URL"});

   factory RecipeModel.fromMap(Map recipe){
      return RecipeModel(
         name: recipe["label"],
         imgUrl: recipe["image"],
         calorie: recipe["calories"],
         appurl: recipe["url"]
      );
   }
}