import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urjotsav/student/sevents.dart';
import '../welcome.dart';
import '../color.dart';
import 'aboutme/about.dart';
import 'aboutme/gallery.dart';
import 'aboutme/graph.dart';
import 'shome.dart';

class Sbottom extends StatefulWidget {
  @override
  State<Sbottom> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<Sbottom> {
  //---------------------------------------------------------------------- coins calculation function starts here
  int totalCoins = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalCoins();
  }

  Future<void> calculateTotalCoins() async {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user!.email;

    final participationRef =
        FirebaseFirestore.instance.collection('Participation');

    final leaderQuery =
        participationRef.where('leaderEmail', isEqualTo: userEmail);
    final firstMemberQuery =
        participationRef.where('firstMemberEmail', isEqualTo: userEmail);
    final secondMemberQuery =
        participationRef.where('secondMemberEmail', isEqualTo: userEmail);
    final thirdMemberQuery =
        participationRef.where('thirdMemberEmail', isEqualTo: userEmail);

    final leaderSnapshot = await leaderQuery.get();
    final firstMemberSnapshot = await firstMemberQuery.get();
    final secondMemberSnapshot = await secondMemberQuery.get();
    final thirdMemberSnapshot = await thirdMemberQuery.get();

    final leaderDocs = leaderSnapshot.docs;
    final firstMemberDocs = firstMemberSnapshot.docs;
    final secondMemberDocs = secondMemberSnapshot.docs;
    final thirdMemberDocs = thirdMemberSnapshot.docs;

    final allDocs = [
      ...leaderDocs,
      ...firstMemberDocs,
      ...secondMemberDocs,
      ...thirdMemberDocs,
    ];

    int coins = allDocs.length * 20;

    setState(() {
      totalCoins = coins;
    });
  }

  bool isSaved = false;
//-----------------------------------------refresh firestore
  void refreshFirebaseData() async {
    //--------------------------------------------- if coins reaches 100 coins
    if (totalCoins >= 100 && !isSaved) {
      final user = FirebaseAuth.instance.currentUser;
      // final userEmail = user!.email;
      final String uid = user!.uid;
      //---------------------------------------------- get data from student signup collection
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Student_Signup')
          .doc(uid)
          .get();
      //-------------------------------------------------------------- retreive data if data exists
      if (docSnapshot.exists) {
        final Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;
        final String name = userData['Name'] as String;
        final String email = userData['Email'] as String;
        final String mobile = userData['Mobile'] as String;
        final String branch = userData['Branch'] as String;
        final String year = userData['Year'] as String;
        final String college = userData['College'] as String;
        //--------------------------------------------------------------------- create a collection called HighCoins
        final highCoinsRef = FirebaseFirestore.instance.collection('HighCoins');
        //--------------------------------------------------------------------------- save the data to that collection
        highCoinsRef
            .doc()
            .set({
              'email': email,
              'name': name,
              'mobile': mobile,
              'year': year,
              'branch': branch,
              'college': college,
              'coins': totalCoins,
            })
            .then((value) => isSaved = true)
            //------------------------------------------------------------------- error while saving the data to HighCoins collection
            // ignore: invalid_return_type_for_catch_error
            .catchError((error) => Fluttertoast.showToast(
                msg: "Error while saving the data",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0));
      } else {
        //-------------------------------------------------------------- current user not found or it dont have 100 coins
        Fluttertoast.showToast(
            msg: "It seems that you don\'t have 100 coins",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    setState(() {
      totalCoins = 0; // Reset totalCoins to 0 before refreshing
    });

    calculateTotalCoins();
  }

//--------------------------------------------------------------------------------------------// retreivinng current user and uid
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
      //--------------------------------------------------------------------- header or app bar
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
          //------------------------------------------------------------ Display coins
          Container(
            width: 100,
            alignment: Alignment.center,
            child: InkWell(
              child: totalCoins > 0
                  ? Row(
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/prestigion.png',
                          ),
                        ),
                        Text(
                          '$totalCoins',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                      ],
                    )
                  : Text(
                      'Wait..',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
              onTap: () {
                refreshFirebaseData();
              },
            ),
          ),
        ],
      ),
      //----------------------------------------------------------------------------------------------side drawer
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
                        //------------------------------------------------------------------- drawer profile image
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profile.png'),
                          backgroundColor: Colors.transparent,
                          radius: 55,
                        ),
                        //-------------------------------------------------------------------------- current user name
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
             
             //------------------------------------------------------------------------------------------------------- masonry layout
            Container( 
              padding: EdgeInsets.all(10),
              color: Color.fromARGB(51, 126, 197, 255),
              child: InkWell(
                child: Text(
                  'Our Prestigians',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.blueYogx, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Gallery(),
                      ));
                },
              ),
            ),
                 SizedBox(
              height: 10,
            ),
              //------------------------------------------------------------------------------------------------------- analysis
            Container( 
              padding: EdgeInsets.all(10),
              color: Color.fromARGB(51, 126, 197, 255),
              child: InkWell(
                child: Text(
                  'Analysis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.blueYogx, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraphPage(),
                      ));
                },
              ),
            ),
                 SizedBox(
              height: 10,
            ),
            //------------------------------------------------------------------------------------------------------- about us page
            Container( 
              padding: EdgeInsets.all(10),
              color: Color.fromARGB(51, 126, 197, 255),
              child: InkWell(
                child: Text(
                  'AboutUs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.blueYogx, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => About(),
                      ));
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //-------------------------------------------------------------------- logout button
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
            ),
          ],
        ),
      ),
      //--------------------------------------------------------------------------------------navigation bar bottom
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
      //------------------------------------------------------------------------------------actual home page of student
      return Center(
        child: Shome(),
      );
    } else {
      //----------------------------------------------------------------------------------------- events of participated student
      return Center(
        child: Sevents(),
      );
    }
  }
}
