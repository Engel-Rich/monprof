import 'package:flutter/material.dart';

bool stringTobool(String element) {
  return (element.toLowerCase().trim() == "0" ||
          element.toLowerCase().trim() == 'false')
      ? false
      : true;
}

bool piecejointe(var value) {
  if (value == null) {
    return false;
  } else {
    return true;
  }
}

bool etatAffiche(int etat) {
  if (etat == 0) {
    return false;
  } else {
    return true;
  }
}
