import 'package:flutter/material.dart';
import 'package:imgtag/models/user_model.dart';
import 'package:imgtag/services/database_service.dart';

class NotificationScreen extends StatefulWidget {
  final String userId;
  final User user;
  NotificationScreen({this.user, this.userId});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  List<Map> _notificationsList = List<Map>();

  @override
  void initState() {
    super.initState();
    _notifications();
  }

  _notifications() async {
    final notifications = await DatabaseService.notifications(widget.userId);
    print(notifications);
    setState(() {
      _notificationsList = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: 'PTSerif',
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            notificationCard(context, items[0]),
            notificationCard(context, items[1]),
            notificationCard(context, items[2]),
            notificationCard(context, items[3]),
            notificationCard(context, items[4]),
            notificationCard(context, items[5]),
            notificationCard(context, items[6]),
          ],
        ),
      )),
    );
  }

  Widget notificationCard(BuildContext context, item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Dismissible(
        key: Key(item),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          setState(() {
            items.removeAt(item);
          });
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            "$item dismissed",
            style: TextStyle(
              fontFamily: 'PTSerif',
            ),
          )));
        },
        child: Material(
          elevation: 5,
          shadowColor: Colors.black54,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  width: 0.1,
                )),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
                      height: 45,
                      width: 45,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                          "Moin Ghadiyali Liked your Photo you posted 10 days ago. Please go and check.",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 13,fontFamily: 'PTSerif',),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
