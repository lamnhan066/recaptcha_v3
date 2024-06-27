import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recaptcha_v3/recaptcha_v3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Recaptcha.ready("6LfrUQIqAAAAANcqDEjzz54Zy3niDcGg04wKEPEj"); //--2

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = 'Click the below button to generate token';
  bool badgeVisible = true;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getToken() async {
    String token = await Recaptcha.execute('submit') ?? 'null returned';
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recaptcha V3 Web example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SelectableText('Token: $_token\n'),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: getToken,
                    child: const Text('Get new token'),
                  ),
                  if (!badgeVisible) const RecaptchaBrand(),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  if (badgeVisible) {
                    Recaptcha.hideBadge();
                  } else {
                    Recaptcha.showBadge();
                  }
                  setState(() {
                    badgeVisible = !badgeVisible;
                  });
                },
                icon: const Icon(Icons.legend_toggle),
                label: const Text("Toggle Badge Visibilty"),
              ),
              TextButton.icon(
                  label: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(
                        text: "https://pub.dev/packages/recaptcha_v3"));
                  },
                  icon: const SelectableText(
                      "https://pub.dev/packages/recaptcha_v3")),
            ],
          ),
        ),
      ),
    );
  }
}
