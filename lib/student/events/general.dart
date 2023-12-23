import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'eventsview.dart';

class generalEvents extends StatefulWidget {
  @override
  State<generalEvents> createState() => _generalEventsState();
}

class _generalEventsState extends State<generalEvents> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Events')
          .where('eventType', isEqualTo: 'General')
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
