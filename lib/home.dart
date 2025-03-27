import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idkfirbase/categories/updatecategory.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text("Homepage "),
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
      body: isLoading == true
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
                        desc: 'are you sure from the deleting process',
                        btnOkText: ("update"),
                        btnOkOnPress: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Updatecategory(
                                  oldName: data[index]['name'],
                                  docId: data[index].id)));
                        },
                        btnCancelText: ("delete"),
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(data[index].id)
                              .delete();
                          print("done deleting");
                          Navigator.of(context).pushReplacementNamed("home");
                        },
                      ).show();
                    },
                    child: Card(
                      child: Container(
                        child: Column(children: [
                          Image.asset(
                            "assets/images/folder4.png",
                            height: 120,
                          ),
                          Text("${data[index]['name']}")
                        ]),
                      ),
                    ));
              },
            ),
    );
  }
}
