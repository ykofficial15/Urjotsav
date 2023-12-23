// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:urjotsav/smooth.dart';
import 'package:urjotsav/student/forgetpassword.dart';
import 'package:urjotsav/student/sbottom.dart';
import 'color.dart';
import 'faculty/fbottom.dart';
import 'student/signup.dart';

class Welcome extends StatefulWidget {
  // const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  int? _selectedIndex = 0;
  late String semail, spassword;
  late String femail, fpassword;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//------------------------------------------------------------------------------------------------- Student Login
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _checkUserExist() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: semail,
          password: spassword,
        );
        Fluttertoast.showToast(
          msg: 'Login successful!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.greenYogx,
          textColor:AppColors.whiteYogx,
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Sbottom()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: "User not found for that email",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: AppColors.redYogx,
              timeInSecForIosWeb: 1,
              textColor:AppColors.whiteYogx,
              fontSize: 16.0);
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: "Entered wrong password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: AppColors.redYogx,
              timeInSecForIosWeb: 1,
              textColor:AppColors.whiteYogx,
              fontSize: 16.0);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error in saving data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.redYogx,
            timeInSecForIosWeb: 1,
            textColor:AppColors.whiteYogx,
            fontSize: 16.0);
      }
    }
  }

  //----------------------------------------------------------------------------------------------------- Faculty Login
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  void _checkTeacherExist() async {
    final form2 = _formKey2.currentState;
    if (form2!.validate()) {
      form2.save();
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: femail,
          password: fpassword,
        );
        Fluttertoast.showToast(
          msg: 'Login successful!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.greenYogx,
          textColor:AppColors.whiteYogx,
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Fbottom()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: "User not found for that email",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: AppColors.redYogx,
              timeInSecForIosWeb: 1,
              textColor:AppColors.whiteYogx,
              fontSize: 16.0);
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: "Entered wrong password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: AppColors.redYogx,
              timeInSecForIosWeb: 1,
              textColor:AppColors.whiteYogx,
              fontSize: 16.0);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error in saving data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.redYogx,
            timeInSecForIosWeb: 1,
            textColor:AppColors.whiteYogx,
            fontSize: 16.0);
      }
    }
  }

//------------------------------------------------------------------------------------------------------ Form 1 and Form 2 Shifting
  void _onIndexChanged(int? index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.f1, AppColors.f2],
            begin: Alignment.centerLeft,
            tileMode: TileMode.mirror,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
//--------------------------------------------------------------------------------------------------------------------------College Heading
            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              decoration: BoxDecoration(
                color: AppColors.whiteYogx,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              width: MediaQuery.of(context).size.width,
              child: Image.asset("assets/heading.png"),
            ),
            //--------------------------------------------------------------------------------------------------------------------------Radio Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                ),
                Radio(
                  overlayColor: MaterialStatePropertyAll(AppColors.denseWhite),
                  focusColor: AppColors.whiteYogx,
                  fillColor: MaterialStatePropertyAll(AppColors.whiteYogx),
                  value: 0,
                  groupValue: _selectedIndex,
                  onChanged: _onIndexChanged,
                ),
                Text(
                  'Student',
                  style: TextStyle(color:AppColors.whiteYogx),
                ),
                SizedBox(width: 10),
                Radio(
         overlayColor: MaterialStatePropertyAll(AppColors.denseWhite),
                  focusColor: AppColors.whiteYogx,
                  fillColor: MaterialStatePropertyAll(AppColors.whiteYogx),
                  value: 1,
                  groupValue: _selectedIndex,
                  onChanged: _onIndexChanged,
                ),
                Text(
                  'Faculty',
                  style: TextStyle(color:AppColors.whiteYogx),
                ),
              ],
            ),
//------------------------------------------------------------------------------------------------ Radio Button Indexing
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
//------------------------------------------------------------------------------------------------------------------ Form 1
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
//------------------------------------------------------------------------------------------------------------------ Login Headings
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Urjotsav 2K24',
                                style: TextStyle(
                                  color: AppColors.whiteYogx,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Login to PIEMR App',
                                style: TextStyle(
                                  color: AppColors.blackYogx,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 44.0,
                        ),
//---------------------------------------------------------------------------------------------------------- Form 1 Fields
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Column(
                            children: [
                              //---------------------------------------------------------- Email Field
                              TextFormField(
                                 style: TextStyle(color: AppColors.whiteYogx),
                                cursorColor: AppColors.whiteYogx,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: "Enter your email",
                                  hintStyle: TextStyle(
                                      color: AppColors.transparentYogx),
                                  labelText: "Student Email",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .whiteYogx), // Set your desired underline color here
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .transparentYogx), // Set your desired unfocused border color here
                                  ),
                                  labelStyle:
                                      TextStyle(color: AppColors.whiteYogx),
                                  prefixIcon:
                                      Icon(Icons.mail, color:AppColors.whiteYogx),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                onSaved: (value) => semail = value!,
                              ),
                              const SizedBox(
                                height: 26.0,
                              ),
                              //------------------------------------------------------------------------ Password Field
                              TextFormField(
                                 style: TextStyle(color: AppColors.whiteYogx),
                                obscureText: true,
                                cursorColor: AppColors.whiteYogx,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: "Enter your password",
                                  hintStyle: TextStyle(
                                      color: AppColors.transparentYogx),
                                  labelText: "Password",
                                  labelStyle:
                                      TextStyle(color: AppColors.whiteYogx),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .whiteYogx), // Set your desired underline color here
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .transparentYogx), // Set your desired unfocused border color here
                                  ),
                                  prefixIcon: Icon(Icons.lock_person_rounded,
                                      color:AppColors.whiteYogx),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                onSaved: (value) => spassword = value!,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              //---------------------------------------------------------------------------- Register
                              FittedBox(
                                child: Row(children: [
                                  const Text(
                                    'Dont have an account?  ',
                                    style: TextStyle(color:AppColors.whiteYogx),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SmoothPageRoute(
                                          child: Signup(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Register Now',
                                      style: TextStyle(
                                          color: AppColors.blackYogx,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Text(
                                    '  or  ',
                                    style: TextStyle(color:AppColors.whiteYogx),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SmoothPageRoute(
                                          child: ForgetPassword(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                          color: AppColors.blackYogx,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 88.0,
                        ),
//-------------------------------------------------------------------------------------------------------- Form 1 Login Button
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          width: double.infinity,
                          child: RawMaterialButton(
                            fillColor: AppColors.whiteYogx,
                            elevation: 0.0,
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            onPressed: () {
                              _checkUserExist();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: AppColors.main,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //----------------------------------------------------------------------------------------------------- Form 2
                  Form(
                    key: _formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
//------------------------------------------------------------------------------------------------------------------ Login Headings
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Urjotsav 2K24',
                                style: TextStyle(
                                  color: AppColors.blackYogx,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Login as faculty',
                                style: TextStyle(
                                  color: AppColors.whiteYogx,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 44.0,
                        ),
//---------------------------------------------------------------------------------------------------------- Form 2 Fields
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Column(
                            children: [
                              //---------------------------------------------------------- Email Field
                              TextFormField(
                                 style: TextStyle(color: AppColors.whiteYogx),
                                cursorColor: AppColors.whiteYogx,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: "Enter your email",
                                  hintStyle: TextStyle(
                                      color: AppColors.transparentYogx),
                                  labelText: "Faculty Email",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .whiteYogx), // Set your desired underline color here
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .transparentYogx), // Set your desired unfocused border color here
                                  ),
                                  labelStyle:
                                      TextStyle(color: AppColors.whiteYogx),
                                  prefixIcon:
                                      Icon(Icons.mail, color:AppColors.whiteYogx),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                onSaved: (value) => femail = value!,
                              ),
                              const SizedBox(
                                height: 26.0,
                              ),
                              //------------------------------------------------------------------------ Password Field
                              TextFormField(
                                 style: TextStyle(color: AppColors.whiteYogx),
                                obscureText: true,
                                cursorColor: AppColors.whiteYogx,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: "Enter your password",
                                  hintStyle: TextStyle(
                                      color: AppColors.transparentYogx),
                                  labelText: "Password",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .whiteYogx), // Set your desired underline color here
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors
                                            .transparentYogx), // Set your desired unfocused border color here
                                  ),
                                  labelStyle:
                                      TextStyle(color: AppColors.whiteYogx),
                                  prefixIcon: Icon(Icons.lock_person_rounded,
                                      color:AppColors.whiteYogx),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                onSaved: (value) => fpassword = value!,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              // Container(
                              //   child: Row(children: [
                              //     const Text(
                              //       'Dont have an account?  ',
                              //       style: TextStyle(color:AppColors.whiteYogx),
                              //     ),
                              //     GestureDetector(
                              //       onTap: () {
                              //         Navigator.push(
                              //           context,
                              //           SmoothPageRoute(
                              //             child: Fsignup(),
                              //           ),
                              //         );
                              //       },
                              //       child: Text(
                              //         'Register Now',
                              //         style: TextStyle(
                              //             color: AppColors.blackYogx,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ),
                              //     const Text(
                              //       '  or  ',
                              //       style: TextStyle(color:AppColors.whiteYogx),
                              //     ),
                              //     GestureDetector(
                              //       onTap: () {
                              //         Navigator.push(
                              //           context,
                              //           SmoothPageRoute(
                              //             child: Welcome(),
                              //           ),
                              //         );
                              //       },
                              //       child: Text(
                              //         'Forgot Password',
                              //         style: TextStyle(
                              //             color: AppColors.blackYogx,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ),
                              //   ]),
                              // )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 88.0,
                        ),
//-------------------------------------------------------------------------------------------------------- Form 2 Login Button
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          width: double.infinity,
                          child: RawMaterialButton(
                            fillColor: AppColors.whiteYogx,
                            elevation: 0.0,
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            onPressed: () {
                              _checkTeacherExist();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: AppColors.main,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
