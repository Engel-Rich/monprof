import 'package:flutter/material.dart';

Widget bouton2(String name, void Function()? press, String image) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 250.0, minHeight: 60.0),
    margin: const EdgeInsets.all(10),
    color: Colors.blue,
    child: TextButton(
      onPressed: press,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              CircleAvatar(
                foregroundColor: Colors.black12,
                child: Image.asset(image),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
