
import 'package:image_picker/image_picker.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idkfirbase/categories/updatecategory.dart';
import 'package:idkfirbase/note/viewnote.dart';
import 'dart:io';



class Filterr extends StatefulWidget {
  
  const Filterr({super.key});

  @override
  State<Filterr> createState() => _FilterrState();
}

class _FilterrState extends State<Filterr> {
  List<QueryDocumentSnapshot> dataUser = [];
 
    File ? file ;

    getImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? imgCamera= await picker.pickImage(source: ImageSource.camera);
 
      setState(() {
             file = File(imgCamera!.path);
      });
    }

  @override
  void initState() {
    print("hm");

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("filter"),
        ),
        body: Container(
          child: Column(
            children: [
              MaterialButton(onPressed: (){
                getImage();
              },
              child: Text("add img from here"),
              ),
              if(file != null) Image.file(file!)
            ],
          ),
        )
        );
  }
}
