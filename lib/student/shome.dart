import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:urjotsav/student/slideshow.dart';
import '../color.dart';
import 'events/culture.dart';
import 'events/general.dart';
import 'events/sports.dart';
import 'events/technical.dart';

class Shome extends StatefulWidget {
  @override
  _ShomeState createState() => _ShomeState();
}

class _ShomeState extends State<Shome>
//--------------------------------------------------------------------- tab layout controller
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Add this line

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
              'DASHBOARD',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.blueYogx),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber, //New
                  blurRadius: 2.0,
                )
              ],
            ),
            //--------------------------------------------------------------------image slideshow
            child: SlideshowWidget(),
          ),
          Container(
            color: AppColors.greenYogx,
            child: SizedBox(
              height: 25, // Adjust the height as needed
              child: Marquee(
                text: "Welcome to the official app of urjotsav 2k24",
                style: TextStyle(fontSize: 15, color: AppColors.whiteYogx),
                scrollAxis: Axis.horizontal,
                blankSpace: 20.0, // Adjust the blankSpace as needed
                velocity: 100.0, // Adjust the velocity as needed
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 0.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          //-------------------------------------------------------------tab bar
          TabBar(
            dividerColor: AppColors.blueYogx,
            labelColor: AppColors.blueYogx,
            controller: _tabController,
            tabs: [
              Tab(text: 'Culture'),
              Tab(text: 'Technical'),
              Tab(text: 'Sports'),
              Tab(text: 'General'),
            ],
          ),
          //--------------------------------------------------------------------------- tab bar components
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                culturalEvents(),
                technicalEvents(),
                sportsEvents(),
                generalEvents(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
