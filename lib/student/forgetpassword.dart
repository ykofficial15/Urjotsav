import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urjotsav/color.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emailController = TextEditingController();

  void sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.redYogx,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        print('Password reset email sent');
        Fluttertoast.showToast(
            msg: "Check Your Mail",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.blueYogx,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        print('Failed to send password reset email: $e');
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            Fluttertoast.showToast(
              msg: 'Email does not exist',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor:AppColors.redYogx,
              textColor: Colors.white,
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Failed to send password reset email',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor:AppColors.redYogx,
              textColor: Colors.white,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to send password reset email',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor:AppColors.redYogx,
            textColor: Colors.white,
          );
        }
      }
    }
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
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 150),
              Container(
                margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'Reset Your Password',
                  style: TextStyle(
                    color: AppColors.whiteYogx,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'Here',
                  style: TextStyle(
                    color: AppColors.blackYogx,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  cursorColor: AppColors.whiteYogx,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyle(color: AppColors.transparentYogx),
                    labelText: "Email",
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
                    labelStyle: TextStyle(color: AppColors.whiteYogx),
                    prefixIcon: Icon(Icons.mail, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.whiteYogx)),
                  onPressed: () =>
                      sendPasswordResetEmail(_emailController.text),
                  child: Text('Send Reset Email',
                      style: TextStyle(
                          color: AppColors.blueYogx,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
