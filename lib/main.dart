import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter_facebook_app_links/flutter_facebook_app_links.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _deepLink = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getDeepLink();
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