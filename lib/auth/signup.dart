import 'package:flutter/material.dart';
import 'package:idkfirbase/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();

GlobalKey <FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Image.asset(
                      "images/megamenu.png", // Ensure this path is correct
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "signup",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Signup to continue using the app",
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("email"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextForm(
                  hintText: "enter ur email to signup",
                  Mycontroller: email,
                  validator: (val) {
                    if (val == "") {
                      return " u can not sign in with empty fields ";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Username "),
                SizedBox(
                  height: 10,
                ),
                CustomTextForm(
                  hintText: "enter ur username",
                  Mycontroller: username,
                  validator: (val) {
                    if (val == "") {
                      return " u can not sign in with empty fields ";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("password"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextForm(
                  hintText: "enter ur PASSWORD to signup ",
                  Mycontroller: password,
                  validator: (val) {
                    if (val == "") {
                      return " u can not sign in with empty fields ";
                    }
                    return null;
                  },
                ),
                Container(
                  height: 20,
                )
              ],
            ),
            ),
            CustomMaterialButton(
              color: Colors.amber,
              title: "Login",
              onPressed: () async {
                if(formState.currentState!.validate()){
                  print("Login button pressed!"); // Debugging

                String userEmail = email.text.trim();
                String userPassword = password.text.trim();

                print("Email entered: '$userEmail'");
                print("Password entered: '$userPassword'");

                if (userEmail.isEmpty || userPassword.isEmpty) {
                  print("Email or password is empty!");
                  return;
                }

                try {
                  print("Attempting Firebase login...");
                  final credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: userEmail,
                    password: userPassword,
                  );

                  print("Login successful: ${credential.user?.email}");
                 
                  await Future.delayed(Duration(seconds: 2));
                   FirebaseAuth.instance.currentUser!.sendEmailVerification();
                 Navigator.of(context).pushReplacementNamed("login");
                } on FirebaseAuthException catch (e) {
                  print("Firebase Auth Exception: ${e.code}");

                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Incorrect password.');
                  } else {
                    print("Firebase Error: ${e.message}");
                  }
                } catch (e, stacktrace) {
                  print("Login error: $e");
                  print("Stacktrace: $stacktrace");
                }
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              //InkWell is a Flutter widget that adds a ripple effect when tapped.
              // It makes any widget tappable and gives it a material-like click animation.
              onTap: () {
                Navigator.of(context).pushReplacementNamed("login");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: "Already have an account ?"),
                  TextSpan(
                      text: "  login ", style: TextStyle(color: Colors.amber))
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
