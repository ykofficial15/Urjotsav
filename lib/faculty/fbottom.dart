import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urjotsav/faculty/fevents.dart';
import 'package:urjotsav/faculty/fhome.dart';
import '../welcome.dart';
import '../color.dart';

class Fbottom extends StatefulWidget {
  @override
  State<Fbottom> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<Fbottom> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() { 
    User? user = _auth.currentUser;
    return user;
  }

  String? getCurrentUID() {
    User? user = getCurrentUser();
    String? uid = user?.uid;
    return uid;
  }

  Future<String?> getUserName(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Student_Signup').doc(uid).get();
    if (snapshot.exists) {
      return snapshot['Name'];
    } else {
      return null;
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueYogx,
        automaticallyImplyLeading: false,
        title: Text('Urjotsav 2K24'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
                (Route<dynamic> route) => false,
              );
            },
            child: Icon(Icons.logout),
            tooltip: 'LogOut',
            elevation: 0,
            autofocus: false,
            backgroundColor: Color.fromARGB(0, 244, 67, 54),
            focusColor: Color.fromARGB(0, 244, 67, 54),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.blueYogx),
              child: FutureBuilder(
                future: getUserName(getCurrentUID()!),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data != null) {
                    return Container(
                        child: Column(
                      children: [
                        CircleAvatar(
                            radius: 35,
                            child: Icon(
                              Icons.person,
                              size: 35,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${snapshot.data}',
                          style: TextStyle(
                              color: AppColors.whiteYogx, fontSize: 15),
                        ),
                      ],
                    ));
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        'User Not Logged In',
                        style:
                            TextStyle(color: AppColors.whiteYogx, fontSize: 20),
                      ),
                    );
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: _buildPageContent(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.blueYogx,
        height: 50,
        items: <Widget>[
          Icon(Icons.home_outlined, size: 30, color: AppColors.whiteYogx),
          Icon(
            Icons.event_available_outlined,
            size: 30,
            color: AppColors.whiteYogx,
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  } 

  Widget _buildPageContent() {
    if (_selectedIndex == 0) {
      return Center(
        child: Fhome(),
      );
    } else {
      return Center(
        child: Fevents(),
      );
    }
  }
}
