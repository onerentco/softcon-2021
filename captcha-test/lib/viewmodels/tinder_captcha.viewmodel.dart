import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:softcon_captcha/data/tinder_data.dart';
import 'package:softcon_captcha/models/tinder.dart';

import '../enums/tinder_category.dart';

class TinderCaptchaViewModel with ChangeNotifier {
  TinderCaptchaViewModel() {
    init();
  }

  bool isLastItemCorrect = true;
  late String task;

  final List<Tinder> _tinderData = <Tinder>[];

  bool _isDragging = false;
  Offset _position = Offset.zero;
  double _angle = 0;
  Size _screenSize = Size.zero;
  bool _isLoggedIn = false;

  UnmodifiableListView<Tinder> get tinderData =>
      UnmodifiableListView<Tinder>(_tinderData);
  double get angle => _angle;
  Offset get position => _position;
  bool get isDragging => _isDragging;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void init() {
    if (_tinderData.isNotEmpty) {
      _tinderData.clear();
    }

    // randomizer
    final int randomCategory = Random().nextInt(3);
    final TinderCategory category = randomCategory.convertFromInt;

    switch (category) {
      case TinderCategory.cat:
        task = 'Match if the picture contains a cat.';
        _tinderData.addAll(TinderData.catEntriesData);
        break;
      case TinderCategory.dog:
        task = 'Match if the picture contains a dog.';
        _tinderData.addAll(TinderData.dogEntriesData);
        break;
      default:
        task = 'Match if the picture contains a mountain.';
        _tinderData.addAll(TinderData.mountainsEntriesData);
        break;
    }
    _tinderData.shuffle();
    isLastItemCorrect = true;
    notifyListeners();
  }

  void startPosition(DragStartDetails details) {
    if (_isDragging) {
      return;
    }
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final double x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();
    final bool? status = getStatus(isForced: true);
    if (status != null) {
      if (status) {
        swipeRight();
      } else {
        swipeLeft();
      }
    } else {
      resetPosition();
    }
  }

  double getStatusOpacity() {
    const int delta = 100;
    final double pos = max(_position.dx.abs(), _position.dy.abs());
    final double opacity = pos / delta;
    return min(opacity, 1);
  }

  bool? getStatus({bool isForced = false}) {
    final double x = _position.dx;

    if (isForced) {
      const int delta = 100;
      if (x >= delta) {
        return true;
      } else if (x <= -delta) {
        return false;
      }
    } else {
      const int delta = 20;
      if (x >= delta) {
        return true;
      } else if (x <= -delta) {
        return false;
      }
    }
    return null;
  }

  void swipeLeft() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);

    if (_tinderData.last.isTrue) {
      isLastItemCorrect = false;
      _tinderData.clear();
      resetPosition();
    } else {
      _nextCard();
    }

    notifyListeners();
  }

  void swipeRight() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    if (_tinderData.last.isTrue) {
      _nextCard();
    } else {
      isLastItemCorrect = false;
      _tinderData.clear();
      resetPosition();
    }

    notifyListeners();
  }

  Future<void> _nextCard() async {
    if (_tinderData.isEmpty) {
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 200));
    _tinderData.removeLast();
    resetPosition();
  }

  void resetPosition() {
    _isDragging = false;

    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  void setScreenSize(Size size) => _screenSize = size;
}
