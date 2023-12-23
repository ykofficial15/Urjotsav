// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urjotsav/color.dart';
import 'package:urjotsav/student/participants/sparticipants.dart';

class eventsView extends StatefulWidget {
  final String eventId;

  eventsView({required this.eventId});

  @override
  State<eventsView> createState() => _eventsViewState();
}
 
class _eventsViewState extends State<eventsView> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getEvent() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Events')
        .doc(widget.eventId)
        .get();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getEvent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
            Map<String, dynamic> eventData = snapshot.data!.data()!;
            String eventName = eventData['eventName'];
            String eventType = eventData['eventType'];
            String eventOrganizers = eventData['eventOrganizers'];
            String eventDesc = eventData['eventDescription'];
            String imageUrl = eventData['image_url'];
            String organizersUid=eventData['uid'];

            return SingleChildScrollView(
              child: Column(
                children: [
                  if (imageUrl != null)
                    Container(
                      margin: EdgeInsets.all(5),
                      height: 450,
                      width: MediaQuery.sizeOf(context).width,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        height: 450,
                      ),
                    ),
                  ListTile(
                    title: Text(eventName,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.blueYogx,fontSize: 25),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Text.rich(
            TextSpan(
              text: 'Event Type: ',
                  style: TextStyle(color:AppColors.blueYogx,fontWeight:FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: '$eventType',
                   style: TextStyle(color:AppColors.blackYogx,fontWeight:FontWeight.bold),
                )
              ]
            )
          ),
                           SizedBox(height: 5,),
                            Text.rich(
            TextSpan(
              text: 'Event Organizers: ',
                  style: TextStyle(color:AppColors.blueYogx,fontWeight:FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: '$eventOrganizers',
                   style: TextStyle(color:AppColors.blackYogx,fontWeight:FontWeight.bold),
                )
              ]
            )
          ),
          SizedBox(height: 5,),
                            Text.rich(
            TextSpan(
              text: 'About Event: ',
                  style: TextStyle(color:AppColors.blueYogx,fontWeight:FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: '$eventDesc',
                   style: TextStyle(color:AppColors.blackYogx,fontWeight:FontWeight.bold),
                )
              ]
            )
          ),
                   
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Sparticipants(OrganizerId:organizersUid,EventType:eventType,EventImage:imageUrl,EventName:eventName),
                            ));
                      },
                      child: Text('Participate Now'))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
