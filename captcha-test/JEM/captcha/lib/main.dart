import 'dart:math';

import 'package:captcha/data/app_value.dart';
import 'package:captcha/model/captcha_object.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppValue.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: AppValue.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<CaptchaObject> captchaObjects = <CaptchaObject>[
    new CaptchaObject(
      AppValue.blackCar,
      AppValue.blackCarValues,
      AppValue.blackCarOptions,
    ),
    new CaptchaObject(
      AppValue.blueCar,
      AppValue.blueCarValues,
      AppValue.blueCarOptions,
    ),
    new CaptchaObject(
      AppValue.grayCar,
      AppValue.grayCarValues,
      AppValue.grayCarOptions,
    ),
    new CaptchaObject(
      AppValue.orangeCar,
      AppValue.orangeCarValues,
      AppValue.orangeCarOptions,
    ),
    new CaptchaObject(
      AppValue.yellowCar,
      AppValue.yellowCarValues,
      AppValue.yellowCarOptions,
    ),
  ];

  List<String> _captchaObjectValues;
  Map<String, bool> _captchaObjectOptions;
  String _captchaObjectImage = "";
  String _validateCaptchaObjectResult = "";

  void _generateCaptcha() {
    final random = new Random();
    var captchaObject = captchaObjects[random.nextInt(captchaObjects.length)];
    setState(() {
      _captchaObjectImage = captchaObject.image;
      _captchaObjectValues = captchaObject.values;
      _captchaObjectOptions = captchaObject.options;

      _resetOptionStateSelected();
    });
  }

  void _resetOptionStateSelected() {
    _captchaObjectOptions.forEach((key, value) {
      _captchaObjectOptions[key] = false;
    });
    _validateCaptchaObjectResult = "";
  }

  void _validateCaptcha() {
    var validOption = 0;
    _captchaObjectValues.forEach((element) {
      _captchaObjectOptions.forEach((key, value) {
        if (element == key && value) {
          validOption++;
        }
      });
    });
    setState(() {
      if (validOption == _captchaObjectValues.length) {
        _validateCaptchaObjectResult = AppValue.correct;
      } else {
        _validateCaptchaObjectResult = AppValue.incorrect;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Text(
              '$_validateCaptchaObjectResult',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            Image(
              height: 200,
              fit: BoxFit.cover,
              image: AssetImage('$_captchaObjectImage'),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: _captchaObjectOptions.keys.map((String option) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.fromLTRB(120, 0, 120, 0),
                  title: Text(option),
                  value: _captchaObjectOptions[option],
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      _captchaObjectOptions[option] = value;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: _validateCaptcha,
              child: Text(AppValue.validate),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateCaptcha,
        label: Text(AppValue.generate),
      ),
    );
  }
}
