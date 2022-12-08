import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:monprof/UI/home.dart';
import 'package:monprof/back-end/api.dart';
import 'package:monprof/back-end/transition.dart';

import '../back-end/model.dart';

class Question extends StatefulWidget {
  final String idmat;
  final String idtrim;

  const Question({
    Key? key,
    required this.idmat,
    required this.idtrim,
  }) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

var titreController = TextEditingController();
var descController = TextEditingController();
var formKey = GlobalKey<FormState>();

bool loading = false;

class _QuestionState extends State<Question> {
  //fonction pour l'envoie de message dans le forum
  List<Map<String, dynamic>> listsujetfinal = [];
  Future<void> ajoutsujet(String desc, String title) async {
    List<Map<String, dynamic>> listsujet = [];
    final url = Uri(
        scheme: 'http',
        host: '$domain',
        port: port,
        path: 'monprof/web/consultation/sujetService.php',
        queryParameters: {
          "requete_type": '1',
          'libelle': title,
          'description': desc,
          'id_categorie': widget.idtrim,
          'id_matiere': widget.idmat,
          'id_classe': Eleve.idClasse,
          'id_eleve': Eleve.sessionEleve.idEleve,
        });
    //print("l'url est : " + url.toString());
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint("les sujets sont:" + data.toString());
      for (var x in data) {
        listsujet.add({
          'id': x['id'],
          'libelle': x['libelle'],
          'description': x['description'],
          'type': x['type'],
          'montant': x['montant'],
          'file_name': x['file_name'],
        });
      }
    }
    setState(() {
      listsujetfinal = listsujet;
      // listcourvide = false;
    });
  }

  //fonction pour la recupération des messages dans le forum
  List<Map<String, dynamic>> listemessage = [];
  Future<List<Map<String, dynamic>>> recuplistesujets(
      String desc, String title) async {
    List<Map<String, dynamic>> listmes = [];
    final url = Uri(
        scheme: 'http',
        host: '$domain',
        port: port,
        path: 'monprof/web/consultation/sujetService.php',
        queryParameters: {
          "requete_type": '2',
          'id_categorie': widget.idtrim,
          'id_matiere': widget.idmat,
          'id_classe': Eleve.idClasse,
        });
    //print("l'url est : " + url.toString());
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('les nouvs ' + response.body);
      debugPrint("les messages recus sont:" + data.toString());
      for (var x in data) {
        listmes.add({
          'id': x['id'],
          'libelle': x['libelle'],
          'description': x['description'],
          'resolu': x['resolu'],
          'pieceJointe': x['pieceJointe'],
          'reponse': x['reponse'],
          'etat': x['etat'],
          "flex": false,
        });
      }
    }
    setState(() {
      listemessage = listmes;
    });
    return listemessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Entrez votre question ",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: titreController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrez le titre';
                          } else {
                            null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.blue.withOpacity(0.2),
                          filled: true,
                          hintText: "titre",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: null,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: descController,
                        minLines: 6,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrez la description';
                          } else {
                            null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.blue.withOpacity(0.2),
                          filled: true,
                          hintText: "description",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: null,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        margin: const EdgeInsets.all(15),
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });

                              String title = titreController.text;
                              String desc = descController.text;
                              var result = await ajoutsujet(desc, title);
                              var recupliste =
                                  await recuplistesujets(desc, title);

                              setState(() {
                                loading = false;
                              });

                              Navigator.of(context).pop();
                              Fluttertoast.showToast(
                                msg: 'Votre question a été soumise avec succes',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor:
                                    Colors.blue.shade400.withOpacity(0.9),
                                timeInSecForIosWeb: 4,
                              );
                              // var code = codeController.text;
                              // String? status = await activationcompte(code);
                              // print(status);

                              // if (status.toString() == '2') {
                              //   Fluttertoast.showToast(
                              //     msg: "Ativation reussi",
                              //     timeInSecForIosWeb: 3,
                              //   );
                              //   Navigator.pop(context);
                              // } else if (status.toString() == '1') {
                              //   Fluttertoast.showToast(
                              //     msg: "CODE Déja Utilisé",
                              //     timeInSecForIosWeb: 5,
                              //   );
                              // } else {
                              //   Fluttertoast.showToast(
                              //     msg: "Code invalide",
                              //     timeInSecForIosWeb: 3,
                              //   );
                              // }

                            } else {
                              return;
                            }
                          },
                          child: const Text(
                            "envoyer",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue,
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
