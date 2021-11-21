import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:softcon_captcha/captcha_screens/login.view.dart';
import 'package:softcon_captcha/data/tinder_data.dart';
import 'package:softcon_captcha/models/tinder.dart';

import 'captcha_screens/tinder_captcha/tinder_captcha.view.dart';
import 'viewmodels/tinder_captcha.viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // lazy loading of images
    for (final Tinder tinder in TinderData.catEntriesData) {
      precacheImage(NetworkImage(tinder.urlImage), context);
    }
    for (final Tinder tinder in TinderData.dogEntriesData) {
      precacheImage(NetworkImage(tinder.urlImage), context);
    }
    for (final Tinder tinder in TinderData.mountainsEntriesData) {
      precacheImage(NetworkImage(tinder.urlImage), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<TinderCaptchaViewModel>(
          create: (_) => TinderCaptchaViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Captcha SoftCon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Selector<TinderCaptchaViewModel, bool>(
          builder: (_, bool isLoggedIn, __) {
            if (isLoggedIn) {
              return const TinderCaptchaView();
            }
            return const LoginView();
          },
          selector: (_, TinderCaptchaViewModel viewModel) =>
              viewModel.isLoggedIn,
        ),
      ),
    );
  }
}
