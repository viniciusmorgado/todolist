// Define as caracteristicas principais do modelo "item".
class Item {
  String title;
  bool done;
  
  // Inicializador para Item
  Item({this.title, this.done});

  Item.fromJson(Map<String, dynamic> json){
    title = json['title'];
    done = json['done'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['title'] = this.title;
  data['done'] = this.done;
  return data;
}
}

