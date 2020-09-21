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
            notificationCard(
              context,
              items[0],
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
              'Moin Ghadiyali liked your Photo you posted.',
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
            ),
            notificationCard(
              context,
              items[1],
              'https://firebasestorage.googleapis.com/v0/b/imagetagger-ee91a.appspot.com/o/images%2Fposts%2Fpost_8e0f9420-ac4f-417c-8f00-8ec9968a1c46.jpg?alt=media&token=b11c4cd5-56fa-4aa4-a868-82f0fa11867e',
              'Hritik Vejare liked your Photo you posted.',
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
            ),
            notificationCard(
              context,
              items[2],
              'https://i.pinimg.com/originals/15/fb/5d/15fb5ddf48ce92d5109334693786a818.jpg',
              'Jay Haria liked your Photo you posted.',
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
            ),
            notificationCard(
              context,
              items[3],
              'https://www.secondwavemedia.com/southwest-michigan/galleries/levi-berkshire-2019.jpg',
              'Zeel Shah liked your Photo you posted.',
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
            ),
            notificationCard(
              context,
              items[4],
              'https://i.pinimg.com/originals/ae/8c/b1/ae8cb11f328d95dffa3068ce1ef27f5f.jpg',
              'Tanvi Patel liked your Photo you posted.',
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
            ),
            notificationCard(
              context,
              items[5],
              'https://www.holidify.com/images/bgImages/MANALI.jpg',
              'Hitesh Gouda liked your Photo you posted.',
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
            ),
            notificationCard(
              context,
              items[6],
              'https://www.tripsavvy.com/thmb/ou60kCMk96AXPhp6xA54ItajAEs=/3751x2813/smart/filters:no_upscale()/manali-india-657d891cdec84fee85ac417c22c3bb0d.jpg',
              'Nishant Gajra liked your Photo you posted.',
              'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
            ),
          ],
        ),
      )),
    );
  }

  Widget notificationCard(
      BuildContext context, item, profileImage, message, image) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                    profileImage,
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
                        message,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    image,
                    height: 60,
                    width: 60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
