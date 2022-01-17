import 'package:flutter/material.dart';

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateBack(context) {
  Navigator.pop(
    context,
  );
}

void navigateToAndFinish(context, widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}
