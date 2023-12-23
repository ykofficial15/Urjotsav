import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParticipantsView extends StatelessWidget {
  final String eventImage;

  ParticipantsView({required this.eventImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants View'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Participation')
            .where('eventImage', isEqualTo: eventImage)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> event = document.data() as Map<String, dynamic>;

                String eventImage = event['eventImage'];
                String teamName = event['teamName'];
                String leader = event['leaderName'];

                return ListTile(
                  leading: Image.network(eventImage),
                  title: Text(teamName),
                  subtitle: Text(leader), 
                );
              }).toList(),
            );
          }

          return Text('No events found for the teacher.');
        },
      ),
    );
  }
}
