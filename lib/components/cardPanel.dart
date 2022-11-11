import 'package:flutter/material.dart';

Widget CardPanel(
    context, String title, data, Color colorback, Color colordata) {
  return Container(
    height: 250,
    width: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: colorback,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Divider(
            thickness: 5,
            color: colordata,
          ),
          const SizedBox(
            height: 60,
          ),
          Center(
            child: CircleAvatar(
              backgroundColor: colordata,
              maxRadius: 50,
              child: Text(
                data,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: colorback),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
