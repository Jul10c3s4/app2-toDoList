class Todo {
  Todo({required this.title, required this.dateTime});

  String title;
  DateTime dateTime;

  get titleText => this.title;

  get dateText => this.dateTime;

//Pega o json e tranforma em todo
  Todo.FromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['dateTime']);

//Pega o tipo todo e tranforma em um json
  Map<dynamic, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String()};
  }
}
