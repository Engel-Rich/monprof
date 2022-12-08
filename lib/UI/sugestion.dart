import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:monprof/back-end/api.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({Key? key}) : super(key: key);

  @override
  _SuggestionState createState() => _SuggestionState();
}

var titreController = TextEditingController();
var descController = TextEditingController();
var formKey = GlobalKey<FormState>();

bool loading = false;
String? valeur;

//  http://$domain/monprof/web/consultation/suggestionService.php?requete_type=1&libelle=Test&description=test
class _SuggestionState extends State<Suggestion> {
  //la fonction activationcompte a pour but f'activer le compte
  void suggestion(String titre, String desc) async {
    final uri = Uri(
        scheme: 'http',
        port: port,
        host: '$domain',
        path: 'monprof/web/consultation/suggestionService.php',
        queryParameters: {
          "requete_type": '1',
          "libelle": titre,
          "desciption": desc,
        });
    final result = await http.post(uri);
    if (result.statusCode == 200) {
      var data = jsonDecode(result.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    var listtrimDow;
    var trimestre;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remarques - Suggestions"),
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
//liste
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          focusColor: Colors.white,
                          value: valeur,
                          //elevation: 5,
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: <String>[
                            'Ajout',
                            'Fonctionnement',
                            'Erreur survenue',
                            'Problème d utilisation',
                            'Autres (A préciser) ',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            "choisir le sujet",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              valeur = value;
                            });
                          },
                        ),
                      ),

                      // TextFormField(
                      //   controller: titreController,
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Veuillez entrez le titre';
                      //     } else {
                      //       null;
                      //     }
                      //   },
                      //   decoration: InputDecoration(
                      //     fillColor: Colors.blue.withOpacity(0.2),
                      //     filled: true,
                      //     hintText: "titre",
                      //     border: OutlineInputBorder(
                      //       borderSide: BorderSide.none,
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      //   onTap: null,
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: descController,
                        minLines: 6,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez indiquer votre suggestion';
                          } else {
                            null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.blue.withOpacity(0.2),
                          filled: true,
                          hintText: "Votre texte",
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
                              // var titre = titreController.text;
                              var titre = valeur.toString();
                              var desc = descController.text;
                              print('la description est :$titre');
                              var resul = suggestion(titre, desc);
                              // var code = codeController.text;
                              // String? status = await activationcompte(code);
                              // print(status);

                              // if (status.toString() == '2') {
                              //   Fluttertoast.showToast(
                              //     msg: "Ativation reussi",
                              //     timeInSecForIosWeb: 3,
                              //   );
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const TransitionPage()));
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
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                msg:
                                    'Votre suggestion a été soumise avec succes',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor:
                                    Colors.blue.shade400.withOpacity(0.9),
                                timeInSecForIosWeb: 4,
                              );

                              setState(() {
                                loading = false;
                              });
                            } else {
                              return;
                            }
                          },
                          child: const Text(
                            "Envoyer",
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
