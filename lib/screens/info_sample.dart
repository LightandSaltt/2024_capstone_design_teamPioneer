//테스트화면 입니다.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'hansik_main_page.dart';

class InfoSample extends StatefulWidget {
  const InfoSample({super.key});

  @override
  State<InfoSample> createState() => _InfoSampleState();
}

final nameController = TextEditingController();
final databaseReference = FirebaseDatabase.instance.ref().child("DataStore");

class _InfoSampleState extends State<InfoSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("hansik"),
      ),
      body: Column(
        children: [
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2,
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                )
              ),
            )
            ),
          ),
          SizedBox(height: 25,),
          ElevatedButton(onPressed: () {
            databaseReference.child("a").set({
              'title' : "hari",
              'id' : 1,
            });
          }, child: Text("Add"),
          )
        ],
      ),

    );
  }
}
