import 'package:ImageTagging/common/custom_app_bar.dart';
import 'package:ImageTagging/screens/home1.dart';
import 'package:ImageTagging/screens/home_screen.dart';
import 'package:ImageTagging/utils/strings.dart';
import 'package:ImageTagging/utils/text_styles.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  static final String id = "landing_screen";
  final String userId;
  LandingScreen({this.userId});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/elephant.jpg",
            height: height,
            fit: BoxFit.fitHeight,
          ),
          Column(
            children: <Widget>[
              CustomAppBar(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 32.0,
                  left: 32,
                  right: 32,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: Strings.READY_TO_WATCH,
                        style: TextStyles.bigHeadingTextStyle,
                      ),
                      TextSpan(text: "\n"),
                      TextSpan(
                        text: Strings.READY_TO_WATCH_DESC,
                        style: TextStyles.bodyTextStyle,
                      ),
                      TextSpan(text: "\n"),
                      TextSpan(text: "\n"),
                      TextSpan(
                        text: Strings.START_TAGGING,
                        style: TextStyles.buttonTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: -30,
            right: -30,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, HomeScreen.id);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDAD4CC).withOpacity(0.8),
                ),
                child: Align(
                  alignment: Alignment(-0.4, -0.4),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
