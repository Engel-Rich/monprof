import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:monprof/UI/home.dart';
import 'package:monprof/back-end/api.dart';
import 'package:monprof/back-end/transition.dart';

import '../back-end/model.dart';

class ActiveCompte extends StatefulWidget {
  const ActiveCompte({Key? key}) : super(key: key);

  @override
  _ActiveCompteState createState() => _ActiveCompteState();
}

var codeController = TextEditingController();
var formKey = GlobalKey<FormState>();
bool active = false;
bool loading = false;
List<Map<String, dynamic>> listActive = [];

class _ActiveCompteState extends State<ActiveCompte> {
  //la fonction activationcompte a pour but f'activer le compte
  Future<String?> activationcompte(String code) async {
    final uri = Uri(
        scheme: 'http',
        host: '$domain',
        path: '/monprof/web/consultation/codeActivationService.php',
        queryParameters: {
          "requete_type": '1',
          "code_generer": code,
          "id_eleve": Eleve.sessionEleve.idEleve,
        });
    //print(uri);
    final result = await http.get(uri);
    if (result.statusCode == 200) {
      var data = jsonDecode(result.body);
      //debugPrint("les datas rdu code " + data.toString());
    }
    return result.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activer un abonnement"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "S'il vous plait, veuillez entrer le code d'activation"
                      "reçu par SMS ou par mail.",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: codeController,
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Veuillez entrer un code d'activation";
                        } else {
                          null;
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.blue.withOpacity(0.2),
                        filled: true,
                        hintText: "Code activation",
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

                            var code = codeController.text;
                            String? status = await activationcompte(code);
                            print(status);

                            if (status.toString() == '2') {
                              Fluttertoast.showToast(
                                msg: "Ativation reussi",
                                timeInSecForIosWeb: 3,
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TransitionPage()));
                            } else if (status.toString() == '1') {
                              Fluttertoast.showToast(
                                msg: "CODE Déja Utilisé",
                                timeInSecForIosWeb: 5,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "Code invalide",
                                timeInSecForIosWeb: 3,
                              );
                            }

                            setState(() {
                              loading = false;
                            });
                          } else {
                            return;
                          }
                        },
                        child: const Text(
                          "Activer",
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
    );
  }
}
