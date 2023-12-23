import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'fparticipantsview.dart';

class Fevents extends StatefulWidget {
  @override
  _FeventsState createState() => _FeventsState();
}

class _FeventsState extends State<Fevents> {
  //-----------------------------------------------------------------------------------------------Saving data to related event id to firebase
  late Future<List<Event>> _eventDetails;

  @override
  void initState() {
    super.initState();
    _eventDetails = fetchEventDetails();
  }

  Future<List<Event>> fetchEventDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Events')
        .where('uid', isEqualTo: uid)
        .get();

    List<Event> events = [];

    snapshot.docs.forEach((doc) {
      Event event = Event(
        id: doc.id,
        name: doc['eventName'],
        type: doc['eventType'],
        image: doc['image_url'],
      );
      events.add(event);
    });

    return events;
  }

//---------------------------------------------------------------------------------------------------------------------------Event Delete Button
  Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Events')
          .doc(eventId)
          .delete();
      Fluttertoast.showToast(
        msg: 'Event Deleted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Event Deletion Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Event>>(
        future: _eventDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<Event> events = snapshot.data!;
//----------------------------------------------------------------------------------------------- List View Builder Started From Here
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              Event event = events[index];

              return InkWell(
                onTap: () {

                  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ParticipantsView(eventImage: event.image),
    ),
  );
                },
                child: ListTile(
                  leading: Image.network(event.image),
                  title: Text(event.name),
                  subtitle: Text(event.type),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Event'),
                            content: Text(
                                'Are you sure you want to delete this event?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  deleteEvent(event.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

//------------------------------------------------------------------------------------------------Class of query snapshot that requires the details
class Event {
  final String id;
  final String name;
  final String type;
  final String image;

  Event(
      {required this.id,
      required this.name,
      required this.type,
      required this.image});
}
