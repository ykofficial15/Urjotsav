import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../color.dart';

class SParticipantsView extends StatefulWidget {
  final String eventId;

  SParticipantsView({required this.eventId});

  @override
  _SParticipantsViewState createState() => _SParticipantsViewState();
}

class _SParticipantsViewState extends State<SParticipantsView> {
  Map<String, dynamic>? eventDetails;

  @override
  void initState() {
    super.initState();
    retrieveEventDetails();
  }

  Future<void> retrieveEventDetails() async {
    final DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('Participation')
        .doc(widget.eventId)
        .get();

    if (eventSnapshot.exists) {
      final eventData = eventSnapshot.data() as Map<String, dynamic>;
      setState(() {
        eventDetails = eventData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (eventDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Event Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final String eventImage = eventDetails!['eventImage'] ?? '';
    final String teamName = eventDetails!['teamName'] ?? '';
    final String leaderName = eventDetails!['leaderName'] ?? '';
    final String firstMemberName = eventDetails!['firstMemberName'] ?? '';
    final String secondMemberName = eventDetails!['secondMemberName'] ?? '';
    final String thirdMemberName = eventDetails!['thirdMemberName'] ?? '';
    final String firstMemberEmail = eventDetails!['firstMemberEmail'] ?? '';
    final String secondMemberEmail = eventDetails!['secondMemberEmail'] ?? '';
    final String thirdMemberEmail = eventDetails!['thirdMemberEmail'] ?? '';
    final String leaderEmail = eventDetails!['leaderEmail'] ?? '';
    final String eventName = eventDetails!['eventName'] ?? '';
    final String eventType = eventDetails!['eventType'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        
        child:Column(
        children: [
            Container(
                       margin: EdgeInsets.fromLTRB(0,5,0, 10),
              color: Colors.amber,
            child: Image.network(eventImage,
            height: 300,
            width: MediaQuery.sizeOf(context).width,
            ),
            // Additional styling as needed
          ),
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Team Name: $teamName',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
              Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Event Name: $eventName',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Event Type: $eventType',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Leader Name: $leaderName',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Leader Email: $leaderEmail',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('First Member Name: $firstMemberName',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
              Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('First Member Email: $firstMemberEmail',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Second Member Name: $secondMemberName',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
           Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Second Member Email: $secondMemberEmail',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Third Member Name: $thirdMemberName',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
        
           
            Container(
             alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Text('Third Member Email: $thirdMemberEmail',style: TextStyle(color:AppColors.blueYogx,fontWeight: FontWeight.bold)),
            // Additional styling as needed
          ),
          
        
        ],
      ),),
    );
  }
}
