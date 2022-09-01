import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class todoListItem extends StatelessWidget {
  const todoListItem({Key? key, required this.tarefa, required this.onDelete})
      : super(key: key);

  final Function(Todo) onDelete;
  final Todo tarefa;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.blue.shade100,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(tarefa.dateTime),
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  tarefa.titleText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            )),
        startActionPane: ActionPane(motion: DrawerMotion(), children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              onDelete(tarefa);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: null,
            backgroundColor: Colors.blue,
            icon: Icons.star,
            label: "curtir",
          )
        ]),
        endActionPane: const ActionPane(motion: ScrollMotion(), children: [
          SlidableAction(
            onPressed: null,
            backgroundColor: Colors.orange,
            icon: Icons.search,
          )
        ]),
      ),
    );
  }

  void delete(BuildContext context) {
    onDelete(tarefa);
  }
}
