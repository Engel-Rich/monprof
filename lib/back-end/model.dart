import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monprof/back-end/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Eleve {
  String? idEleve;
  String? nom;
  String? sexe;
  String? email;
  final String classe;
  String? ecole;
  final String telephone;
  static Map<String, dynamic> listclasse = {};
  String idc;
  Eleve({
    this.idEleve,
    this.nom,
    this.sexe,
    this.email,
    this.ecole,
    required this.classe,
    required this.idc,
    required this.telephone,
  });
  static Eleve sessionEleve =
      Eleve(classe: '', telephone: '', idEleve: '', idc: '');
  static String idClasse = "";

  //login function

  // Future login(String password) async {
  //   final uri = Uri(
  //     scheme: "http",
  //     host: 'www.ess-ucac.org',
  //     path: "/web/consultation/eleveService.php?requete_type=1",
  //   );
  //   var response = await http.post(uri, body: {
  //     'classe': classe,
  //     'passe_eleve': password,
  //     "matricule_eleve": telephone
  //   });
  //   if (response.statusCode == 200) {
  //     var result = Map<String, dynamic>.from(jsonDecode(response.body));
  //     // debugPrint(result.toString());
  //     return result;
  //   } else {
  //     return response.statusCode.toString();
  //   }
  // }

  Future register(String password) async {
    final uri = Uri.parse(
        'http://$domain:$port/monprof/web/consultation/eleveService.php?requete_type=1&nom=$nom&ecole=$ecole&email=$email&telephone=$telephone&password=$password&sexe=$sexe');
    print(uri);
    var response = await http.post(
      uri,
      // ['Content-Type' => 'application/json;charset=UTF-8', 'Charset' => 'utf-8']
      // headers: {
      //   'Content-Type': 'application/json;charset=UTF-8',
      //   'Charset': 'utf-8',
      // },
      // body: jsonEncode({
      //   'requete_type': '1',
      //   'nom': nom,
      //   'ecole': ecole,
      //   'email': email,
      //   "telephone": telephone,
      //   "password": password,
      //   'sexe': sexe
      // }),
    );
    print(uri);
    if (response.statusCode == 200) {
      print(response.body);

      var parsed = jsonDecode(response.body);
      debugPrint("les datas reçus :" + parsed.toString());
      // print(parsed);
      // print((parsed[0])['id']);
      //return parsed.map<String>((json) => String.fromMap(json)).toList();

      Map<String, String> result = {};
      result['nom'] = nom!;
      result['email'] = email!;
      result['telephone'] = telephone;
      result['ecole'] = ecole!;
      result['classe'] = classe;
      result['sexe'] = sexe!;
      result['idc'] = idc;
      idEleve = result['id'] = (parsed[0])['id'];
      parsed[0] = result;
      print(parsed);
      return parsed;
    } else {
      return response.statusCode.toString();
    }
  }

  factory Eleve.fromJson(Map<String, dynamic> map) => Eleve(
      idEleve: map["id"],
      nom: map["nom"],
      sexe: map["sexe"],
      email: map["email"],
      telephone: map["telephone"],
      ecole: map["ecole"],
      classe: map["classe"],
      idc: map["idc"]);

  Map<String, dynamic> elevetomap() {
    return {
      "classe": classe,
      "telephone": telephone,
      "nom": nom,
      "sexe": sexe,
      "ecole": ecole,
      "id": idEleve,
      "idc": idc,
    };
  }

  static Future<void> saveEleve(Eleve eleve, String idEleve) async {
    debugPrint('sauvegarde de la session');
    // eleve.idc = Eleve.listclasse[eleve.classe];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = jsonEncode(eleve.elevetomap());
    preferences.setString("eleve", data);
    preferences.setString('idEleve', idEleve);

    // ignore: deprecated_member_use
    preferences.commit();
    // debugPrint('La valeur de l\'élève à sauvegarder est :' + data.toString());
    // debugPrint(
    //     'classe apres inscription :,${eleve.idclasse},${eleve.idEleve},${eleve.nom},${eleve.ecole},${eleve.telephone},${eleve.email}');
    // debugPrint("l'Id de la classe est : " + idClass);
  }

  void printinfo() {
    debugPrint(
        'ecole: $ecole, classe: $classe IdEleve: $idEleve, idclasse: $idc');
  }

  static Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("eleve", "");
  }

  static Future<void> getEleve() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString("eleve");
    if (data != null && data != "") {
      var decode = json.decode(data);
      sessionEleve = Eleve.fromJson(decode);
      idClasse = Eleve.sessionEleve.idc;
      sessionEleve.printinfo();
    }
    // var data2 = preferences.getString('idc');
    // idClasse = data2 ?? "";
  }
}

bool isvalidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}
