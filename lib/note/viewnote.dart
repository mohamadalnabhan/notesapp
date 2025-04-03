import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idkfirbase/note/addnote.dart';
import 'package:idkfirbase/note/editnote.dart';

class Viewnote extends StatefulWidget {
  final String categoreyId;
  const Viewnote({super.key, required this.categoreyId});

  @override
  State<Viewnote> createState() => _ViewnoteState();
}

class _ViewnoteState extends State<Viewnote> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoreyId)
        .collection("note")
        .get();
    setState(() {
      isLoading = false;
      data.addAll(querySnapshot.docs);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Addnote(
                      docid: widget.categoreyId,
                    )));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: Text("note"),
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
                icon: Icon(Icons.exit_to_app_outlined))
          ],
        ),
        body: PopScope(
          canPop: false, // Prevents automatic back navigation
          onPopInvoked: (didPop) {
            if (didPop) return;
            Navigator.of(context).pushReplacementNamed("home");
          },
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 160),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: ' Error',
                            desc: 'are you sure from the deleting thsi note',
                            btnOkText: ("cancel"),
                            btnOkOnPress: () async {
                              print("cancel");
                            },
                            btnCancelText: ("delete"),
                            btnCancelOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection("categories")
                                  .doc(widget.categoreyId)
                                  .collection("note")
                                  .doc(data[index].id)
                                  .delete();
                              print("done deleting");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Viewnote(
                                      categoreyId: widget.categoreyId)));
                            },
                          ).show();
                        },
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Editnote(
                                  notedocid: data[index].id,
                                  categoreyId: widget.categoreyId,
                                  value: data[index]['note'])));
                        },
                        child: Card(
                          child: Container(
                            child: Column(
                                children: [Text("${data[index]['note']}")]),
                          ),
                        ));
                  },
                ),
        ));
  }
}
