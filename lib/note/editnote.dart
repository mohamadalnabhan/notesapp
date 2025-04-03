import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idkfirbase/components/customaddtf.dart';
import 'package:idkfirbase/components/textformfield.dart';
import 'package:idkfirbase/note/viewnote.dart';

class Editnote extends StatefulWidget {
  final String notedocid ;
  final String categoreyId ;
  final String value ;
  const Editnote({super.key, required this.notedocid, required this.categoreyId, required this.value});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

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


  editNote() async {
      CollectionReference notes =
      FirebaseFirestore.instance.collection("categories").doc(widget.categoreyId).collection("note");
    if (formState.currentState!.validate()) {
    
      try {
        isLoading = true ;
        setState(() {
          
        });
         await notes.doc(widget.notedocid).update({"note" : note.text});
        print("note added");
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Viewnote(categoreyId: widget.categoreyId)));
        
        // ✅ Removes all previous pages and shows home
      } catch (e) {
        isLoading = false;
        setState(() {
          
        });
        print(e);
      }
    }
  }

  @override
  void initState() {
    note.text =widget.value ;
    super.initState();
    
  }
@override
  void dispose(){
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("save"),
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
                      Mycontroller: note,
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
                  editNote();
                },
              ),
            ],
          )),
    );
  }
}
