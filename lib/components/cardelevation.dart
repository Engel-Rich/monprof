import 'package:flutter/material.dart';

Widget cardElevation(
  context,
  MainAxisAlignment espace,
  Widget enfant,
) {
  return Material(
    elevation: 3,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: espace,
        children: [],
      ),
    ),
  );
}
