import 'package:flutter/material.dart';

class PageTransitions {
  static Route<T> createRoute<T>(Widget page) {
    return MaterialPageRoute<T>(
      builder: (context) => page,
    );
  }
}
