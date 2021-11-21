import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:softcon_captcha/models/tinder.dart';
import 'package:softcon_captcha/viewmodels/tinder_captcha.viewmodel.dart';

class TinderCardGesture extends StatefulWidget {
  const TinderCardGesture({
    Key? key,
    required this.tinder,
    required this.isFront,
    required this.index,
  }) : super(key: key);

  final Tinder tinder;
  final bool isFront;
  final int index;

  @override
  _TinderCardGestureState createState() => _TinderCardGestureState();
}

class _TinderCardGestureState extends State<TinderCardGesture> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      const Size size = Size(408, 624);
      context.read<TinderCaptchaViewModel>().setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TinderCaptchaViewModel>(
      builder: (_, TinderCaptchaViewModel viewModel, __) {
        return SizedBox(
          height: 624,
          child: !widget.isFront
              ? _TinderCard(
                  tinder: widget.tinder,
                  index: widget.index,
                )
              : GestureDetector(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final Offset center =
                          constraints.smallest.center(Offset.zero);

                      final double angle = viewModel.angle * pi / 205;
                      final Matrix4 rotatedMatrix = Matrix4.identity()
                        ..translate(center.dx, center.dy)
                        ..rotateZ(angle)
                        ..translate(-center.dx, -center.dy);

                      return AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: Duration(
                          milliseconds: viewModel.isDragging ? 0 : 300,
                        ),
                        transform: rotatedMatrix
                          ..translate(
                            viewModel.position.dx,
                            viewModel.position.dy,
                          ),
                        child: Stack(
                          children: <Widget>[
                            _TinderCard(
                              tinder: widget.tinder,
                              index: widget.index,
                            ),
                            buildStamps(),
                          ],
                        ),
                      );
                    },
                  ),
                  onPanStart: viewModel.startPosition,
                  onPanUpdate: viewModel.updatePosition,
                  onPanEnd: (DragEndDetails details) {
                    viewModel.endPosition();
                  },
                ),
        );
      },
    );
  }

  Widget buildStamps() {
    final TinderCaptchaViewModel viewModel =
        Provider.of<TinderCaptchaViewModel>(context);
    final bool? status = viewModel.getStatus();
    final double opacity = viewModel.getStatusOpacity();
    if (status != null) {
      if (status) {
        final Widget child = _Stamp(
          angle: -0.5,
          color: Colors.green,
          text: 'YES',
          opacity: opacity,
        );

        return Positioned(
          child: child,
          top: 64,
          left: 50,
        );
      } else {
        final Widget child = _Stamp(
          angle: 0.5,
          color: Colors.red,
          text: 'NOPE',
          opacity: opacity,
        );

        return Positioned(
          child: child,
          top: 64,
          right: 50,
        );
      }
    }
    return const SizedBox.shrink();
  }
}

class _TinderCard extends StatelessWidget {
  const _TinderCard({
    Key? key,
    required this.tinder,
    required this.index,
  }) : super(key: key);

  final Tinder tinder;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(tinder.urlImage),
            fit: BoxFit.cover,
            alignment: const Alignment(-0.3, 0),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.transparent,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: <double>[0.7, 1],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Spacer(),
              _CardInfo(
                tinder: tinder,
                index: index,
              ),
              const SizedBox(height: 4),
              const _StatusTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({
    Key? key,
    required this.tinder,
    required this.index,
  }) : super(key: key);

  final Tinder tinder;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          index.toString(),
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '/ 9',
          style: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            context.read<TinderCaptchaViewModel>().task,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({
    Key? key,
    this.angle = 0,
    required this.color,
    required this.text,
    required this.opacity,
  }) : super(key: key);

  final double angle;
  final Color color;
  final String text;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
