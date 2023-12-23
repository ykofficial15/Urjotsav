import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../color.dart';

class Signup extends StatefulWidget {
  // const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? _selectedCollege;
  String? _selectedYear;
  String? _selectedBranch;
  late String sname,
      smobile,
      semail,
      senrollment,
      scollege,
      syear,
      sbranch,
      spassword;
//---------------------------------------- Student Signup
  void saveToFirestore() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        //--------------------------------------------- Save to authentication
        await Firebase.initializeApp();
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: semail,
          password: spassword,
        );
//------------------------------- Save to Student_Signup database
        final uid = userCredential.user!.uid;
        await FirebaseFirestore.instance
            .collection('Student_Signup')
            .doc(uid)
            .set({
          'Name': sname,
          'Email': semail,
          'Password': spassword,
          'Mobile': smobile,
          'College': scollege,
          'Year': syear,
          'Branch': sbranch,
        }).then((result) {
          // Sign up successful
          Fluttertoast.showToast(
              msg: "Registration successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        });

        form.reset();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
              msg: "Too weak password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: "Email already exists",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error in saving data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //---------------------------------------------------------------------------------------------- Student Signup Page Background Color
        child: Container(
          padding: EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.f1, AppColors.f2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------------------------------------------------------------------------- College name header
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
              SizedBox(
                height: 60,
              ),
              //-------------------------------------------------------------------------------------------------- Login Headings
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create a new account',
                      style: TextStyle(
                        color: AppColors.whiteYogx,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Signup to continue',
                      style: TextStyle(
                        color: AppColors.blackYogx,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 44.0,
              ),
              //------------------------------------------------------------------------------------------------ Form Starts From Here
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //------------------------------------------------------------------------------------------------------ Student Name
                      TextFormField(
                        cursorColor: AppColors.whiteYogx,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: "Enter your name",
                            hintStyle:
                                TextStyle(color: AppColors.transparentYogx),
                            labelText: "Student Name",
                            labelStyle: TextStyle(color: AppColors.whiteYogx),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            prefixIcon:
                                Icon(Icons.person, color: AppColors.whiteYogx)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) => sname = value!,
                      ),
                      //------------------------------------------------------------------------------------------------------------ Student Email Address
                      TextFormField(
                        cursorColor: AppColors.whiteYogx,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: "Enter your email",
                            hintStyle:
                                TextStyle(color: AppColors.transparentYogx),
                            labelText: "Student Email",
                            labelStyle: TextStyle(color: AppColors.whiteYogx),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            prefixIcon:
                                Icon(Icons.mail, color: AppColors.whiteYogx)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) => semail = value!,
                      ),

                      //------------------------------------------------------------------------------------------------------------------ Student Mobile Number
                      TextFormField(
                        cursorColor: AppColors.whiteYogx,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: const InputDecoration(
                            hintText: "Enter your mobile number",
                            hintStyle:
                                TextStyle(color: AppColors.transparentYogx),
                            labelText: "Student Mobile",
                            labelStyle: TextStyle(color: AppColors.whiteYogx),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            prefixIcon: Icon(Icons.phone_android_rounded,
                                color: AppColors.whiteYogx)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mobile';
                          }
                          return null;
                        },
                        onSaved: (value) => smobile = value!,
                      ),
                      //----------------------------------------------------------------------------------------------------------------------- Student Enrollment
                      // TextFormField(
                      //   cursorColor: AppColors.whiteYogx,
                      //   keyboardType: TextInputType.text,
                      //   decoration: const InputDecoration(
                      //       hintText: "Enter your enrollment number",
                      //       hintStyle:
                      //           TextStyle(color: AppColors.transparentYogx),
                      //       labelText: "Student Enrollment",
                      //       labelStyle:
                      //           TextStyle(color: AppColors.whiteYogx),
                      //       focusedBorder: UnderlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: AppColors.whiteYogx),
                      //       ),
                      //       enabledBorder: UnderlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: AppColors.whiteYogx),
                      //       ),
                      //       prefixIcon: Icon(Icons.document_scanner_rounded,
                      //           color: AppColors.whiteYogx)),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter your enrollment';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (value) => senrollment = value!,
                      // ),
                      //------------------------------------------------------------------------------College Name Drop Down Menu
                      DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(15),
                        icon: Icon(Icons.arrow_drop_down_circle_rounded,
                            color: AppColors.whiteYogx),
                        dropdownColor: AppColors.whiteYogx,
                        value: _selectedCollege,
                        items: [
                          DropdownMenuItem(
                            child: Text('PIEMR'),
                            value: 'PIEMR',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Other',
                            ),
                            value: 'Other College',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCollege = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select college';
                          }
                          return null;
                        },
                        onSaved: (value) => scollege = value!,
                        decoration: InputDecoration(
                            hintText: "Select college",
                            hintStyle:
                                TextStyle(color: AppColors.transparentYogx),
                            labelText: "College Name",
                            labelStyle: TextStyle(color: AppColors.whiteYogx),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            prefixIcon: Icon(Icons.account_balance,
                                color: AppColors.whiteYogx)),
                      ),
                      //-------------------------------------------------------------------------------------------------------------- Student Year DropDown Menu

                      DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(15),
                        icon: Icon(Icons.arrow_drop_down_circle_rounded,
                            color: AppColors.whiteYogx),
                        dropdownColor: AppColors.whiteYogx,
                        value: _selectedYear,
                        items: [
                          DropdownMenuItem(
                            child: Text('First'),
                            value: 'First Year',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Second',
                            ),
                            value: 'Second Year',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Third',
                            ),
                            value: 'Third Year',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Fourth',
                            ),
                            value: 'Fourth Year',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select year';
                          }
                          return null;
                        },
                        onSaved: (value) => syear = value!,
                        decoration: InputDecoration(
                            hintText: "Select year",
                            hintStyle:
                                TextStyle(color: AppColors.transparentYogx),
                            labelText: "Year",
                            labelStyle: TextStyle(color: AppColors.whiteYogx),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            prefixIcon: Icon(Icons.perm_contact_calendar,
                                color: AppColors.whiteYogx)),
                      ),

                      //------------------------------------------------------------------------------------------------ Student Branch Dropdown Menu

                      DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(15),
                        icon: Icon(Icons.arrow_drop_down_circle_rounded,
                            color: AppColors.whiteYogx),
                        dropdownColor: AppColors.whiteYogx,
                        value: _selectedBranch,
                        items: [
                          DropdownMenuItem(
                            child: Text('Computer Science & Engineering'),
                            value: 'CS',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Artificial Intelligence & Data Science',
                            ),
                            value: 'AIDS',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Automation & Robotics',
                            ),
                            value: 'AR',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Electronics & Communication Engineering',
                            ),
                            value: 'ECE',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Electrical Engineering',
                            ),
                            value: 'EE',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Civil Engineering',
                            ),
                            value: 'CE',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Mechanical Engineering',
                            ),
                            value: 'ME',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Other Branch',
                            ),
                            value: 'Other Branch',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedBranch = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select branch';
                          }
                          return null;
                        },
                        onSaved: (value) => sbranch = value!,
                        decoration: InputDecoration(
                            hintText: "Select branch",
                            hintStyle:
                                TextStyle(color: AppColors.transparentYogx),
                            labelText: "Branch",
                            labelStyle: TextStyle(color: AppColors.whiteYogx),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            prefixIcon:
                                Icon(Icons.school, color: AppColors.whiteYogx)),
                      ),

                      //------------------------------------------------------------------------------------------------------------------ Student Password
                      TextFormField(
                        cursorColor: AppColors.whiteYogx,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Enter your password",
                            hintStyle:
                                TextStyle(color: AppColors.transparentYogx),
                            labelText: "Set Password",
                            labelStyle: TextStyle(color: AppColors.whiteYogx),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteYogx),
                            ),
                            prefixIcon:
                                Icon(Icons.pin, color: AppColors.whiteYogx)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onSaved: (value) => spassword = value!,
                      ),
                      SizedBox(height: 15),
                      //------------------------------------------------------------------------- Signup Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                                'Note: Dear Prestigians! Register\n           With Your College Mail Id',
                                style: TextStyle(
                                    color: AppColors.whiteYogx,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            child: RawMaterialButton(
                              padding: EdgeInsets.all(5),
                              fillColor: AppColors.whiteYogx,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              onPressed: () {
                                saveToFirestore();
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "SignUp",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 21, 255),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      color: Color.fromARGB(255, 0, 21, 255))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
