import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  createAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text('Uma imagem e uma música deve ser inserida!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: createAlertDialog(context),
    );
  }
}
