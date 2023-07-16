import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.amber),
    ),
  );
}

linearaProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Color(0xff94b723)),
    ),
  );
}
