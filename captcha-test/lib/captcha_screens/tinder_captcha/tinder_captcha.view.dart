import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:softcon_captcha/captcha_screens/tinder_captcha/tinder_card.widget.dart';
import 'package:softcon_captcha/viewmodels/tinder_captcha.viewmodel.dart';

class TinderCaptchaView extends StatelessWidget {
  const TinderCaptchaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.blue.shade200,
              Colors.black87,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: 408,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const <Widget>[
                _LogoTile(),
                SizedBox(height: 24),
                Center(
                  child: _TinderCards(),
                ),
                SizedBox(height: 24),
                _TinderButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoTile extends StatelessWidget {
  const _LogoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Icon(
          Icons.local_fire_department_rounded,
          color: Colors.white,
          size: 32,
        ),
        SizedBox(width: 4),
        Text(
          'Tinder Captcha',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _TinderCards extends StatefulWidget {
  const _TinderCards({
    Key? key,
  }) : super(key: key);

  @override
  State<_TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<_TinderCards> {
  double height = 100;
  double weight = 100;

  @override
  Widget build(BuildContext context) {
    return Consumer<TinderCaptchaViewModel>(
      builder: (_, TinderCaptchaViewModel viewModel, __) {
        if (viewModel.tinderData.isEmpty) {
          if (viewModel.isLastItemCorrect) {
            return SizedBox(
              height: 624,
              child: Center(
                child: SvgPicture.asset(
                  'assets/success.svg',
                  height: 416,
                  width: 300,
                ),
              ),
            );
          }
          return SizedBox(
            height: 624,
            child: Center(
              child: SvgPicture.asset(
                'assets/wrong.svg',
                height: 416,
                width: 300,
              ),
            ),
          );
        }

        final List<Widget> tinderCards = <Widget>[];
        for (int i = 0; i < viewModel.tinderData.length; i++) {
          tinderCards.add(
            TinderCardGesture(
              tinder: viewModel.tinderData[i],
              isFront: viewModel.tinderData.last == viewModel.tinderData[i],
              index: i + 1,
            ),
          );
        }

        return Stack(
          children: tinderCards,
        );
      },
    );
  }
}

class _TinderButtons extends StatelessWidget {
  const _TinderButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TinderCaptchaViewModel viewModel =
        Provider.of<TinderCaptchaViewModel>(context);

    final bool? status = viewModel.getStatus();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Selector<TinderCaptchaViewModel, bool>(
          selector: (_, TinderCaptchaViewModel viewModel) =>
              viewModel.isLastItemCorrect && viewModel.tinderData.isNotEmpty,
          builder: (_, bool showButton, __) {
            if (showButton) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.swipeLeft();
                  },
                  style: ButtonStyle(
                    foregroundColor: getColor(
                      Colors.red,
                      Colors.white,
                      status == false,
                    ),
                    backgroundColor: getColor(
                      Colors.white,
                      Colors.red,
                      status == false,
                    ),
                    side: getBorder(
                      Colors.red,
                      Colors.white,
                      status == false,
                    ),
                    shape: MaterialStateProperty.all<CircleBorder>(
                      const CircleBorder(),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                      const EdgeInsets.all(32),
                    ),
                    overlayColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.red[200]
                            : null;
                      },
                    ),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: status == false ? Colors.white : Colors.red,
                    size: 32,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Selector<TinderCaptchaViewModel, bool>(
          selector: (_, TinderCaptchaViewModel viewModel) =>
              viewModel.tinderData.isEmpty,
          builder: (_, bool showButton, __) {
            if (showButton) {
              return ElevatedButton(
                onPressed: () {
                  viewModel.init();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  primary: Colors.white,
                  shape: const CircleBorder(),
                  minimumSize: const Size.square(64),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.yellow,
                  size: 32,
                ),
              );
            }
            return const SizedBox(
              width: 32,
            );
          },
        ),
        Selector<TinderCaptchaViewModel, bool>(
          selector: (_, TinderCaptchaViewModel viewModel) =>
              viewModel.isLastItemCorrect && viewModel.tinderData.isNotEmpty,
          builder: (_, bool showButton, __) {
            if (showButton) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.swipeRight();
                  },
                  style: ButtonStyle(
                    foregroundColor: getColor(
                      Colors.teal,
                      Colors.white,
                      status == true,
                    ),
                    backgroundColor: getColor(
                      Colors.white,
                      Colors.teal,
                      status == true,
                    ),
                    side: getBorder(
                      Colors.teal,
                      Colors.white,
                      status == true,
                    ),
                    shape: MaterialStateProperty.all<CircleBorder>(
                      const CircleBorder(),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                      const EdgeInsets.all(32),
                    ),
                    overlayColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.teal[200]
                            : null;
                      },
                    ),
                  ),
                  // style: ElevatedButton.styleFrom(
                  //   elevation: 8,
                  //   primary: Colors.white,
                  //   shape: const CircleBorder(),
                  //   minimumSize: const Size.square(80),
                  // ),
                  child: Icon(
                    Icons.favorite,
                    color: status == true ? Colors.white : Colors.green,
                    size: 33,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    Color getColor(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    BorderSide getBorder(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    }

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
