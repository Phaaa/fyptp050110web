import 'package:flutter/material.dart';

Future<String?> showGeneralErrorDialog(
    BuildContext context, String errorTitle, String errorContent) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(errorTitle),
      content: Text(errorContent),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: const Text("OK"),
        )
      ],
    ),
  );
}

Future<String?> showGeneralSuccessDialog(
    BuildContext context, String successTitle, String successContent) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(successTitle),
      content: Text(successContent),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: const Text("OK"),
        )
      ],
    ),
  );
}
