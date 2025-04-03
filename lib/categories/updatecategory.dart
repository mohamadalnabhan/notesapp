import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idkfirbase/components/customaddtf.dart';
import 'package:idkfirbase/components/textformfield.dart';

class Updatecategory extends StatefulWidget {
  final String oldName ;
  final String docId ;
  const Updatecategory({super.key, required this.oldName, required this.docId});

  @override
  State<Updatecategory> createState() => _UpdatecategoryState();
}

class _UpdatecategoryState extends State<Updatecategory> {
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
@override
  void initState(){
  super.initState();
  name.text = widget.oldName ; // widget to acess
}
  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");
  updateCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true ;
        setState(() {
          
        });
        await categories.doc(widget.docId)//auto generated
        .set( {"name" :name.text},SetOptions(merge: true));
        print("category updated");
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
  void dispose(){
    super.dispose();
    name.dispose();
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
                  updateCategory();
                },
              ),
            ],
          )),
    );
  }
}
