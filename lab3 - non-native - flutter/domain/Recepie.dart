class Recepie {

  int id;
  String title;
  String type;
  List<String> ingredients;
  String description;

  Recepie(this.id, this.title, this.type, this.ingredients, this.description);
  Recepie.withoutId(this.title, this.type, this.ingredients, this.description);
  
  String ingredientsToString() {
    String result = "";
    for(String ing in ingredients){
      result += " "+ ing;
    }
    return result;
  }
  
}