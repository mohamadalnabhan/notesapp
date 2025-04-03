import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idkfirbase/components/customaddtf.dart';
import 'package:idkfirbase/components/textformfield.dart';
import 'package:idkfirbase/note/viewnote.dart';

class Addnote extends StatefulWidget {
 final docid ;
  const Addnote({super.key, required this.docid});

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
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


  addNote() async {
      CollectionReference notes =
      FirebaseFirestore.instance.collection("categories").doc(widget.docid).collection("note");
    if (formState.currentState!.validate()) {
    
      try {
        isLoading = true ;
        setState(() {
          
        });
        DocumentReference reference = await notes.add(
            {"note": note.text});
        print("note added");
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Viewnote(categoreyId: widget.docid)));
        
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
  void dispose(){
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add note"),
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
                  addNote();
                },
              ),
            ],
          )),
    );
  }
}
