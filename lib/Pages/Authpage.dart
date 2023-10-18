import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _auth = FirebaseAuth.instance;
  static bool isuploadingAuth = false;
  static bool isLoggedIn = true;
  static bool _obscureText = true;
  static bool isDark = false;
  static String dynamicName = "";
  static String name = "";
  static String email = "";
  static String password = "";
  final _key = new GlobalKey<FormState>();

  Future<void> submit() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      if (isLoggedIn) {
        try {
          final userCredentials = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          isLoggedIn = true;
          bool _obscureText = true;
          dynamicName = "";
          name = "";
          email = "";
          password = "";
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Invalid mail or password")));
        }
      } else {
        try {
          final userCredentials = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          FirebaseFirestore.instance
              .collection("usernames")
              .doc('${userCredentials.user!.uid}')
              .set({'Name': name});
          isLoggedIn = true;
          bool _obscureText = true;
          dynamicName = "";
          name = "";
          email = "";
          password = "";
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Invalid mail or password. Try again")));
        }
      }

      isLoggedIn ? print("login") : print(name);
      print(email);
      print(password);
    }
  }

  String getTextBeforeAt(String emailAddress) {
    final atSymbolIndex = emailAddress.indexOf('@');
    if (atSymbolIndex == -1) {
      return emailAddress;
    } else {
      return emailAddress.substring(0, atSymbolIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: [
            IconButton(
              icon: Icon(
                  isDark ? Icons.brightness_4 : Icons.brightness_2_outlined),
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
              },
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: double.infinity,
                // height: double.infinity,
                child: Center(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Center(
                                        child: Text(
                                          isLoggedIn
                                              ? "Welcome " + dynamicName
                                              : "Sign Up",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 35,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Image.asset(isLoggedIn
                                    ? "assets/images/monkey2.png"
                                    : "assets/images/monkey1.png"),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.8, // Set the desired width here
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  // border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Add rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      offset: Offset(0.0, 5.0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextFormField(
                                    // validator: ,
                                    decoration: InputDecoration(
                                      label: Text("Username"),
                                      hintText: "Enter Email Address",
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email cannot be empty";
                                      }
                                    },
                                    onChanged: (value) {
                                      isLoggedIn
                                          ? setState(() {
                                              dynamicName =
                                                  getTextBeforeAt(value);
                                            })
                                          : print('');
                                    },
                                    onSaved: (newValue) {
                                      email = newValue!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              !isLoggedIn
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8, // Set the desired width here
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Add rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              blurRadius: 5.0,
                                              offset: Offset(0.0, 5.0),
                                            ),
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextFormField(
                                          onSaved: (newValue) {
                                            name = newValue!;
                                          },
                                          decoration: InputDecoration(
                                            label: Text("Full Name"),
                                            hintText: "Enter Name",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            !isLoggedIn
                                                ? setState(() {
                                                    dynamicName = value;
                                                  })
                                                : print('not name');
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Name cannot be empty";
                                            }
                                          },
                                          keyboardType: TextInputType.name,
                                          autocorrect: false,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              !isLoggedIn
                                  ? SizedBox(
                                      height: 20,
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.8, // Set the desired width here
                                // height: MediaQuery.of(context).size.height *
                                //     0.11, // Set the desired height here
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Add rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 5.0),
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextFormField(
                                    onSaved: (value) {
                                      password = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password cannot be empty";
                                      } else {
                                        if (value.length < 6) {
                                          return "Password should contain minimum 6 characters";
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                      label: Text("Password"),
                                      hintText: "Enter password",
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscureText
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: _obscureText,
                                    autocorrect: false,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  isLoggedIn
                                      ? TextButton(
                                          onPressed: () => print("forgot"),
                                          child: Text(
                                            "Forgot password?",
                                          ))
                                      : SizedBox(
                                          height: 0,
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          isuploadingAuth = true;
                                        });
                                        await submit();
                                        isuploadingAuth = false;
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.70, // Set the desired width here
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        child: Center(
                                          child: isuploadingAuth
                                              ? CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                )
                                              : Text(
                                                  isLoggedIn
                                                      ? "Login"
                                                      : "Register",
                                                  style: TextStyle(
                                                    color: Colors.white,

                                                    fontSize:
                                                        24, // Adjust the font size as needed
                                                    fontWeight: FontWeight
                                                        .bold, // Make the text bold),
                                                  ),
                                                ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          isLoggedIn
                                              ? "Don't have an account?"
                                              : "You already have an Account?",
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isLoggedIn = !isLoggedIn;
                                                _obscureText = true;
                                                dynamicName = "";
                                                _key.currentState!.reset();
                                              });
                                            },
                                            child: Text(
                                                isLoggedIn
                                                    ? "Sign up"
                                                    : "Login",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary)))
                                      ])
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
