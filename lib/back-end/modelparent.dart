import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monprof/back-end/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parent {
  String? idParent;
  String? nom;
  String? sexe;
  String? email;
  String? telephone;
  String? profession;

  static Map<String, dynamic> listclasse = {};

  Parent({
    this.idParent,
    this.nom,
    this.sexe,
    this.email,
    this.telephone,
    this.profession,
  });
  static Parent sessionParent = Parent(
      idParent: '',
      telephone: '',
      nom: '',
      email: '',
      profession: '',
      sexe: '');

  //Fin du modele parent et des données session

  Future register(String password) async {
    final uri = Uri(
        scheme: 'http',
        host: '$domain',
        path: 'monprof/web/consultation/eleveService.php',
        queryParameters: {
          'requete_type': '3',
          'profession_parent': profession,
          'nom': nom,
          'email': email,
          "telephone": telephone,
          "password": password,
          'sexe': sexe
        });
    var response = await http.post(uri);
    print(uri);
    if (response.statusCode == 200) {
      print(response.body);

      var parsed = jsonDecode(response.body);
      debugPrint("les datas du parent :" + parsed.toString());
      // print(parsed);
      // print((parsed[0])['id']);
      //return parsed.map<String>((json) => String.fromMap(json)).toList();

      Map<String, String> result = {};
      result['nom'] = nom!;
      result['email'] = email!;
      result['telephone'] = telephone!;
      result['profession'] = profession!;
      result['sexe'] = sexe!;
      idParent = result['id'] = (parsed[0])['id'];
      parsed[0] = result;
      print(parsed);
      return parsed;
    } else {
      return response.statusCode.toString();
    }
  }

  factory Parent.fromJson(Map<String, dynamic> map) => Parent(
        idParent: map["id"],
        nom: map["nom"],
        sexe: map["sexe"],
        email: map["email"],
        telephone: map["telephone"],
        profession: map["profession"],
      );

  Map<String, dynamic> parenttomap() {
    return {
      "profession": profession,
      "telephone": telephone,
      "nom": nom,
      "sexe": sexe,
      "email": email,
      "id": idParent,
    };
  }

  static Future<void> saveParent(Parent parent, String idParent) async {
    debugPrint('sauvegarde de la session');
    // eleve.idc = Eleve.listclasse[eleve.classe];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = jsonEncode(parent.parenttomap());
    preferences.setString("parent", data);
    preferences.setString('idParent', idParent);

    // ignore: deprecated_member_use
    preferences.commit();
    // debugPrint('La valeur de l\'élève à sauvegarder est :' + data.toString());
    // debugPrint(
    //     'classe apres inscription :,${eleve.idclasse},${eleve.idEleve},${eleve.nom},${eleve.ecole},${eleve.telephone},${eleve.email}');
    // debugPrint("l'Id de la classe est : " + idClass);
  }

  void printinfo() {
    debugPrint('telephone: $telephone, email: $email idParent: $idParent ');
  }

  static Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("parent", "");
  }

  static Future<void> getParent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString("parent");
    if (data != null && data.trim().isNotEmpty) {
      var decode = json.decode(data);
      sessionParent = Parent.fromJson(decode);
      // idParent = Parent.sessionParent.idParent;
      sessionParent.printinfo();
    }
    // var data2 = preferences.getString('idc');
    // idClasse = data2 ?? "";
  }
}
