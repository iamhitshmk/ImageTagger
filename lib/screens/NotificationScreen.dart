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
            fontFamily: 'Billabong',
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return notificationCard(context, item);
          },
        ),
      ),
    );
  }

  Widget notificationCard(BuildContext context, item) {
    return Padding(
      padding: const EdgeInsets.all(10),
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
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("$item dismissed")));
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          "Moin Ghadiyali Liked your Photo you posted 10 days ago. Please go and check.",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
                      height: 55,
                      width: 55,
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
