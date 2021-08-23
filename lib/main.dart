import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_facebook_app_links/flutter_facebook_app_links.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _deepLink = 'Unknown';
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getDeepLink();
    //setUserProperty();
  }

  Future<void> setUserProperty(deepLink) async {
    await analytics.setUserProperty(name: 'deep_link', value: deepLink);
    await analytics.setUserProperty(name: 'test', value: "test4");

    var uri = Uri.parse(deepLink);

    uri.queryParameters.forEach((k, v) {
      analytics.setUserProperty(name: k, value: v);
    });

    analytics.logAddPaymentInfo();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterFacebookAppLinks.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getDeepLink() async {
    //HashMap linkMap = new HashMap<dynamic, dynamic>();
    String deepLink = "Unknown";

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deepLink = await FlutterFacebookAppLinks.initFBLinks();
      print(deepLink);

    } on PlatformException {
       deepLink = 'Failed to get link.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    setUserProperty(deepLink);
    if (!mounted) return;

    setState(() {
      _deepLink = deepLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('deep link: $_deepLink\n'),
            ]
          )
        ),
      ),
    );
  }
}