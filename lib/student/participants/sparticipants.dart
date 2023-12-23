import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Sparticipants extends StatefulWidget {
  //---------------------------------------------------------------------------------------organizers id from the another page
  final String OrganizerId, EventType,EventImage,EventName;
  Sparticipants({required this.OrganizerId, required this.EventType,required this.EventImage, required this.EventName});

  @override
  State<Sparticipants> createState() => _SparticipantsState();
}

//------------------------------------------------------------------------------------------------ getting current user uid from firebase
final FirebaseFirestore firestore = FirebaseFirestore.instance;
String currentUser = FirebaseAuth.instance.currentUser!.uid;
final _formKey = GlobalKey<FormState>();

//------------------------------------------------------------------------------------------ participateNow() function calling
void _participateNow(String leaderName, String leaderEmail, String organizerId,
    String eventType,String eventImage, String eventName) async {
  try {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save form data to Firestore
      firestore.collection('Participation').add({
        'teamName': teamname,
        'leaderName': leaderName,
        'leaderEmail': leaderEmail,
        'firstMember': firstname,
        'firstMemberEmail': firstemail,
        'secondMember': secondname,
        'secondMemberEmail': secondemail,
        'thirdMember': thirdname,
        'thirdMemberEmail': thirdemail,
        'currentUserId': currentUser,
        'organizerUID': organizerId,
        'eventType': eventType,
        'eventImage':eventImage,
        'eventName': eventName,
      });

      Fluttertoast.showToast(
        msg: 'Participated Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      // Clear form fields after successful submission
      _formKey.currentState!.reset();
    } else {
      Fluttertoast.showToast(
        msg: 'Failed To Participate!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } catch (e) {
    print('Error saving data: $e');
    Fluttertoast.showToast(
      msg: 'Error saving data',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

//------------------------------------------------------------------------------------------------ team members name and email variables
late String firstname, secondname, thirdname, teamname;
late String firstemail, secondemail, thirdemail;

class _SparticipantsState extends State<Sparticipants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---------------------------------------------------------------------------------------------App heading
      appBar: AppBar(title: Text('Participate')),
      //---------------------------------------------------------------------------------------- future builder for getting leader name and email from the firebase
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getCurrentUserData(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                var data = snapshot.data!.data();
                String? name = data?['Name'];
                String? email = data?['Email'];
//------------------------------------------------------------------------------------- form and form key started here
                return Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        //------------------------------------------------------------------------------------ member 1 email
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Team Name',
                            hintText: 'Enter Your Team Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please your team name';
                            }
                            return null;
                          },
                          onSaved: (value) => teamname = value!,
                        ),
                           SizedBox(height: 16.0),
                        //-----------------------------------------------------------------------------leader name from firebase
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Leader Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: Icon(Icons.lock),
                          ),
                          initialValue: name,
                          enabled: false,
                          onSaved: (value) => name = value ?? name,
                        ),
                        SizedBox(height: 16.0),
                        //------------------------------------------------------------------------------leaderemail form firebase
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Leader Roll No.',
                            suffixIcon: Icon(Icons.lock),
                          ),
                          initialValue: email,
                          enabled: false,
                          onSaved: (value) => email = value ?? email,
                        ),
                           SizedBox(height: 16.0),
                        //----------------------------------------------------------------------------------member 1 name
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Member1 Name',
                            hintText: 'Enter First Member Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the member\'s name';
                            }
                            return null;
                          },
                          onSaved: (value) => firstname = value!,
                        ),
                           SizedBox(height: 16.0),
                        //------------------------------------------------------------------------------------ member 1 email
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Member1 Email',
                            hintText: 'Enter First Member Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the member\'s email';
                            }
                            return null;
                          },
                          onSaved: (value) => firstemail = value!,
                        ),
                           SizedBox(height: 16.0),
                        //----------------------------------------------------------------------------------member 2 name
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Member2 Name',
                            hintText: 'Enter Second Member Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the member\'s name';
                            }
                            return null;
                          },
                          onSaved: (value) => secondname = value!,
                        ),
                           SizedBox(height: 16.0),
                        //------------------------------------------------------------------------------------ member 2 email
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Member2 Email',
                            hintText: 'Enter Second Member Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the member\'s email';
                            }
                            return null;
                          },
                          onSaved: (value) => secondemail = value!,
                        ),
                           SizedBox(height: 16.0),
                        //----------------------------------------------------------------------------------member 3 name
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Member3 Name',
                            hintText: 'Enter Third Member Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the member\'s name';
                            }
                            return null;
                          },
                          onSaved: (value) => thirdname = value!,
                        ),
                           SizedBox(height: 16.0),
                        //------------------------------------------------------------------------------------ member 1 email
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Member3 Email',
                            hintText: 'Enter Third Member Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the member\'s email';
                            }
                            return null;
                          },
                          onSaved: (value) => thirdemail = value!,
                        ),
                           SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            String organizerId = widget.OrganizerId;
                            String eventType = widget.EventType;
                            String eventImage=widget.EventImage;
                            String eventName = widget.EventName;
                            _participateNow(
                                name!, email!, organizerId, eventType,eventImage,eventName);
                          },
                          child: Text('Participate'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text('No data available'),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Student_Signup')
          .doc(user.uid)
          .get();
      return snapshot;
    }
    throw Exception('User not logged in');
  }
}
