// screens/list_screen.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/providers/todo_firestore.dart';

// import 'package:flutter_todo/providers/todo_sqlite.dart';
// import 'package:flutter_todo/providers/todo_default.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Todo> todos = [];
  TodoFirebase todoFirebase = TodoFirebase();

  @override
  void initState() {
    super.initState();
    setState(() {
      todoFirebase.initDb().then((value){});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: todoFirebase.todoStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          todos = todoFirebase.getTodos(snapshot);

          return Scaffold(
            appBar: AppBar(
              title: const Text('할 일 목록 앱'),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book),
                        Text('뉴스'),
                      ],
                    ),
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Text(
                '+',
                style: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String title = '';
                      String description = '';
                      return AlertDialog(
                        title: const Text('할 일 추가하기'),
                        content: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  title = value;
                                },
                                decoration: const InputDecoration(labelText: '제목'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  description = value;
                                },
                                decoration: const InputDecoration(labelText: '설명'),
                              )
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              child: const Text('추가'),
                              onPressed: () {
                                Todo newTodo = Todo(
                                    title: title, description: description);
                                todoFirebase.todosReference
                                    .add(newTodo.toMap())
                                    .then((value) {
                                  Navigator.of(context).pop();
                                });
                              }),
                          TextButton(
                            child: const Text('취소'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            body: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todos[index].title),
                    onTap: () {},
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              child: const Icon(Icons.edit),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String title = todos[index].title;
                                      String description =
                                          todos[index].description;
                                      return AlertDialog(
                                        title: const Text('할 일 수정하기'),
                                        content: SizedBox(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              TextField(
                                                onChanged: (value) {
                                                  title = value;
                                                },
                                                decoration: InputDecoration(
                                                    hintText:
                                                        todos[index].title),
                                              ),
                                              TextField(
                                                onChanged: (value) {
                                                  description = value;
                                                },
                                                decoration: InputDecoration(
                                                    hintText: todos[index]
                                                        .description),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('수정'),
                                            onPressed: () {
                                              Todo newTodo = Todo(
                                                title: title,
                                                description: description,
                                                reference:
                                                    todos[index].reference,
                                              );
                                              todoFirebase
                                                  .updateTodo(newTodo)
                                                  .then((value) =>
                                                      Navigator.of(context)
                                                          .pop());
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('취소'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              child: const Icon(Icons.delete),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('할 일 삭제하기'),
                                        content: Container(
                                          child: const Text('삭제하시겠습니까?'),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                todoFirebase
                                                    .deleteTodo(todos[index])
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Text('삭제')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('취소'))
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: todos.length),
          );
        }
      },
    );
  }
}
