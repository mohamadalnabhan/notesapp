import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idkfirbase/components/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;// false cuz i need the the login to bbe displayed
  
  Future signInWithGoogle() async {

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
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
                          "Login",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "login to continue using the app",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("email"),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextForm(
                          hintText: "enter ur email to login",
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
                        Text("password"),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextForm(
                          hintText: "enter ur email to login",
                          Mycontroller: password,
                          validator: (val) {
                            if (val == "") {
                              return " u can not sign in with empty fields ";
                            }
                            return null;
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: ' Error',
                                desc:
                                    'write ur email first to restart ur password  ',
                                btnOkOnPress: () {},
                              ).show();
                              return;
                            }

                            try {
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: ' Error',
                                desc:
                                    'we sent an email so u can reset ur password ',
                                btnOkOnPress: () {},
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: ' Error',
                                desc: 'please enter a valid email',
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            alignment: Alignment.topRight,
                            child: Text("forget password ?"),
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomMaterialButton(
                      color: Colors.amber,
                      title: "Login",
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          print("Login button pressed!"); // Debugging start

                          print("Fetching email & password...");

                          String userEmail = email.text.trim();
                          String userPassword = password.text.trim();

                          print("Email entered: '$userEmail'");
                          print("Password entered: '$userPassword'");

                          try {
                            isLoading = true;
                            setState(() {});/// set state to update the ui
                            print("🛠 Attempting Firebase login...");
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            isLoading = false;
                            setState(() {});
                            if (credential.user!.emailVerified) {
                              Navigator.of(context)
                                  .pushReplacementNamed("home");
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: ' Error',
                                desc: 'verify ur email to continue ',
                                btnOkOnPress: () {},
                              ).show();
                            }

                            print(
                                "✅ Login successful: ${credential.user?.email}");
                          } on FirebaseAuthException catch (e) {
                              isLoading = false;
                            setState(() {});
                            print("❌ Firebase Auth Exception: ${e.code}");

                            Future.delayed(Duration.zero, () {
                              if (e.code == 'user-not-found') {
                                print('❌ No user found for that email.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Login Error',
                                  desc: 'No user found for that email',
                                  btnOkOnPress: () {},
                                ).show();
                              } else if (e.code == 'wrong-password') {
                                print('❌ Incorrect password.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Login Error',
                                  desc: 'Incorrect password.',
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                print("Firebase Error: ${e.message}");
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  title: 'Unknown Error',
                                  desc: e.message ?? "Something went wrong!",
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            });
                          }
                        } else {
                          print("not valid");
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomMaterialButton(
                    color: Colors.redAccent,
                    title: "Login with Google",
                    onPressed: () async {
                      print("🔵 Google Sign-In button pressed!");
                      try {
                        UserCredential userCredential =
                            await signInWithGoogle();
                        print(
                            "✅ Google Sign-In Success: ${userCredential.user?.email}");
                        Navigator.of(context).pushReplacementNamed("home");
                      } catch (e) {
                        print("❌ Google Sign-In Error: $e");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    //InkWell is a Flutter widget that adds a ripple effect when tapped.
                    // It makes any widget tappable and gives it a material-like click animation.
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "do not have an account"),
                        TextSpan(
                            text: "  register ?",
                            style: TextStyle(color: Colors.amber))
                      ])),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
