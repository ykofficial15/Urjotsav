import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urjotsav/student/participants/sparticipantsview.dart';

class Sevents extends StatefulWidget {
  @override
  _SeventsState createState() => _SeventsState();
}

class _SeventsState extends State<Sevents> {
  List<Map<String, dynamic>> eventDetails = [];

  @override
  void initState() {
    super.initState();
    retrieveEventDetails();
  }

  Future<void> retrieveEventDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String userEmail = user.email ?? '';

      final QuerySnapshot participationSnapshot =
          await FirebaseFirestore.instance.collection('Participation').get();

      final List<Map<String, dynamic>> eventDetailsList = [];

      participationSnapshot.docs.forEach((document) {
        final String eventId = document.id;
        final Map<String, dynamic> eventData =
            document.data() as Map<String, dynamic>;
        final String leaderEmail = eventData['leaderEmail'];
        final String firstMemberEmail = eventData['firstMemberEmail'];
        final String secondMemberEmail = eventData['secondMemberEmail'];
        final String thirdMemberEmail = eventData['thirdMemberEmail'];

        if (userEmail == leaderEmail ||
            userEmail == firstMemberEmail ||
            userEmail == secondMemberEmail ||
            userEmail == thirdMemberEmail) {
          final String eventName = eventData['eventName'];
          final String eventImage = eventData['eventImage'];
          final String eventType = eventData['eventType'];

          final eventDetails = {
            'eventId': eventId,
            'eventName': eventName,
            'eventImage': eventImage,
            'eventType': eventType,
          };

          eventDetailsList.add(eventDetails);
        }
      });

      setState(() {
        eventDetails = eventDetailsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(13, 0, 0, 255),
            ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            alignment: Alignment.center,
            width: (MediaQuery.of(context).size.width),
            child: Text(
              'PARTICIPATED EVENTS',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: eventDetails.length,
              itemBuilder: (context, index) {
                final event = eventDetails[index];
                final String eventId = event['eventId'];
                final String eventName = event['eventName'];
                final String eventImage = event['eventImage'];
                final String eventType = event['eventType'];

                return Card(
                  child: ListTile(
                    leading: Image.network(eventImage),
                    title: Text(eventName),
                    subtitle: Text(eventType),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SParticipantsView(eventId: eventId),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
