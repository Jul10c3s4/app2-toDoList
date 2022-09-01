import 'package:app2/repositories/todo_repository.dart';
import 'package:app2/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> tarefas = [];
  String? errorText;
  Todo? deletedTodo;
  int? deletedpos;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        tarefas = value;
        print(tarefas);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          /*leading: IconButton(onPressed: (){
          print("olá");
        },
        icon: Icon(Icons.search),),*/
        ),
        drawer: Drawer(),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.pink.shade200,
            ],
          )),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  /*Expanded ocupa todo o espaço livre.*/
                  Expanded(
                    child: TextField(
                      //O keyboard serve para definir o tipo de teclado que aparecerá na tela, podendo ser, só de números, email, e etc.
                      keyboardType: TextInputType.text,

                      /*onSubmited serve para pegar o valor inserido ao pressiosar a tecla
                   enter e em seguida realizar a função.*/
                      /*
                  onSubmitted: (text){
                    print(text);
                  },*/

                      /*serve para pegar o valor inserido a partir do momento que a letra é digitada
                   e assim já realizar a função(pode ser utilizado em pesquisa).*/
                      /*onChanged: (text){
                    print(text);
                  },*/

                      controller: _controller,
                      decoration: InputDecoration(
                        errorText: errorText,
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                        border: OutlineInputBorder(),
                        //ações após clicar no text field.
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.lightBlueAccent, width: 3)),

                        /*label: Text('insira a tarefa: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),),*/

                        labelText: 'insira a tarefa: ',
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                        hintText: 'EX: fazer dever de casa',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(
                          () {
                            if (_controller.text != "") {
                              Todo tarefa = Todo(
                                  title: _controller.text,
                                  dateTime: DateTime.now());
                              tarefas.add(tarefa);
                              _controller.clear();
                              todoRepository.saveTodoList(tarefas);
                              errorText = null;
                            } else {
                              errorText = "Digite algo";
                              print("digite algo");
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                          "Digite algo",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK"),
                                            style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Colors.lightBlueAccent),
                                          ),
                                        ],
                                      ));
                            }
                            ;
                          },
                        );
                      },
                      onLongPress: () {
                        setState(() {
                          print("segurou");
                        });
                      },
                      child: Text(
                        '+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 2, vertical: 15))),
                ],
              ),
              SizedBox(height: 40),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo tarefa in tarefas)
                      todoListItem(
                        tarefa: tarefa,
                        onDelete: onDelete,
                      ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                        Text('Você possui ${tarefas.length} tarefas pendentes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Limpar Tudo ?"),
                                  content:
                                      const Text('Você deseja apagar tudo ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("cancelar"),
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.red),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        DeleteAll();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Limpar tudo"),
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.lightBlue),
                                    )
                                  ],
                                ));
                      });
                    },
                    child: Text(
                      'Limpar tudo',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }

  void DeleteAll() {
    setState(() {
      tarefas.clear();
    });
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedpos = tarefas.indexOf(todo);

    setState(() {
      tarefas.remove(todo);
    });

    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'tarefa ${todo.titleText} foi removido com sucesso!',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.green,
        onPressed: () {
          setState(() {
            tarefas.insert(deletedpos!, deletedTodo!);
          });
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }
}
