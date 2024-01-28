import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hack_grocery_app/screens/logout_screen.dart';
import 'package:hack_grocery_app/screens/notification_screen.dart';
import 'package:hack_grocery_app/classes/lists.dart';
import 'package:hack_grocery_app/classes/group.dart';
import 'package:hack_grocery_app/classes/user.dart';

class CreateList extends StatefulWidget {
  const CreateList({super.key});

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {

  final _listNameController = TextEditingController();

  Future<void> createGroup(Lists list, Group group) async
  {
    //add the list to the database:
    final db = FirebaseFirestore.instance;
    final docRef = db
    .collection("lists")
    .withConverter(
      fromFirestore: Lists.fromFirestore,
      toFirestore: (Lists list, option) => list.toFirestore(),
    )
    .doc();
    //this method actually adds the list
    await docRef.set(list);

    //add the list to the group
    //what's actually happening is that I add the list to the group
    group.addList(docRef.id);
    final groupRef = db.collection("users").withConverter(
      fromFirestore: Group.fromFirestore, toFirestore: (Group group, option) => group.toFirestore()
      ).doc(FirebaseAuth.instance.currentUser!.uid);
    await groupRef.set(group);

  }

  @override
  Widget build(BuildContext context) {
    final Group group = widget.group;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.green,
      title: Text('Create New List'),
      centerTitle: true,
  ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [ 
        Padding(
          padding: const EdgeInsets.all(25),
            child: TextField(
            controller: _listNameController,
            decoration: InputDecoration(
            hintText: "Enter List Name"
          ),
        ),
      ),
        ElevatedButton(
        onPressed : () {
          var list = Lists(color: 'c77069', name: _listNameController.text.trim(), id: '', item: [],);
          createGroup(list, group);
        },
        child: Text('Create!'),
          ),
         ],
      ),
      ),
    );
  }
}