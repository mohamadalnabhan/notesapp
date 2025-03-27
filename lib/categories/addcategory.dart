import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idkfirbase/components/customaddtf.dart';
import 'package:idkfirbase/components/textformfield.dart';

class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

// CollectionReference categories =
//     FirebaseFirestore.instance.collection('categories');

// Future<void> addCategory() {
//   return categories
//       .add({
//         "name": name.text,
//       })
//       .then((value) => print("category Added"))
//       .catchError((error) => print("Failed to add category: $error"));
// }

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");
  addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true ;
        setState(() {
          
        });
        DocumentReference reference = await categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
        print("category added");
        Navigator.of(context).pushNamedAndRemoveUntil("home",
            (route) => false); // ✅ Removes all previous pages and shows home
      } catch (e) {
        isLoading = false;
        setState(() {
          
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add category"),
      ),
      body:isLoading ? Center(child: CircularProgressIndicator()):
       Form(
          key: formState,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Customaddtf(
                      hintText: "enter the name of ur category",
                      Mycontroller: name,
                      validator: (val) {
                        if (val == "") {
                          return "it can not be empty";
                        }
                        return null;
                      })),
              CustomMaterialButton(
                color: Colors.orangeAccent,
                title: "add",
                onPressed: () {
                  addCategory();
                },
              ),
            ],
          )),
    );
  }
}
