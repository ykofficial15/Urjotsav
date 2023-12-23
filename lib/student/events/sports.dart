import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'eventsview.dart';

class sportsEvents extends StatefulWidget {
  @override
  State<sportsEvents> createState() => _sportsEventsState();
}

class _sportsEventsState extends State<sportsEvents> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Events')
          .where('eventType', isEqualTo: 'Sports')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final events = snapshot.data!.docs;
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final eventName = event['eventName'];
            final eventImage = event['image_url'];
            final eventOrganizer = event['eventOrganizers'];
            final eventUid = event.id;
            return Card(
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(eventName),
                  subtitle: Text(eventOrganizer),
                  leading: Image.network(eventImage),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => eventsView(eventId: eventUid),
                      ),
                    );
                  },
                ));
          },
        );
      },
    );
  }
}
