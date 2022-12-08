// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monprof/UI/contratuser.dart';
import 'package:monprof/UI/loading.dart';
import 'package:monprof/back-end/modelparent.dart';
import 'package:monprof/back-end/transition.dart';
import 'package:monprof/components/input.dart';
import 'package:page_transition/page_transition.dart';

class InscriptionParent extends StatefulWidget {
  const InscriptionParent({Key? key}) : super(key: key);

  @override
  State<InscriptionParent> createState() => _InscriptionParentState();
}

class _InscriptionParentState extends State<InscriptionParent> {
  final numeroController = TextEditingController();
  final nomController = TextEditingController();

  final professionController = TextEditingController();
  final passwordController = TextEditingController();

  final emailController = TextEditingController();
  String? valeursexe;

  bool isloading = false;
  final formKey = GlobalKey<FormState>();

  bool visible = false;
  bool visibleconfir = true;
  String requestError = '';
  late List<Map<String, String>> courliste = [];
  var listCoursDropdown = <String>[];

  late Map<String, String> dataIns;
  bool politique = false;

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text("INSCRIPTION"),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Container(
                            height: 150,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            child: Hero(
                                tag: "photo0",
                                child: Image.asset('assets/book.png'))),
                      ),
                      input(nomController, (nomController) {
                        if (nomController!.isEmpty ||
                            nomController.length > 23) {
                          return 'entrez un nom ';
                        } else {
                          return null;
                        }
                      }, false, const Icon(Icons.person), 'Nom',
                          TextInputType.name, 'Nom obligatoire'),
                      const SizedBox(
                        height: 10,
                      ),
                      input(emailController, (emailController) {
                        if (emailController!.isEmpty) {
                          return 'entrez une adresse valide';
                        } else {
                          return null;
                        }
                      }, false, const Icon(Icons.email), 'Email',
                          TextInputType.emailAddress, 'Email obligatoire'),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                            focusColor: Colors.white,
                            value: valeursexe,
                            alignment: AlignmentDirectional.centerStart,
                            isExpanded: true,
                            style: const TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            iconSize: 30,
                            elevation: 16,
                            underline: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                            ),
                            items: <String>[
                              'FEMME',
                              'HOMME',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            hint: const Text(
                              "Votre Genre",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                valeursexe = value;
                              });
                              Fluttertoast.showToast(
                                msg: 'Vous avez genre est: $valeursexe',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor:
                                    const Color.fromARGB(249, 20, 185, 136)
                                        .withOpacity(0.9),
                                timeInSecForIosWeb: 5,
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      input(numeroController, (value) {
                        if (value!.length < 9 || value.length > 10) {
                          return 'entrez un numéro valide';
                        } else {
                          return null;
                        }
                      }, false, const Icon(Icons.phone), 'Téléphone',
                          TextInputType.phone, 'entre un numéro valide'),
                      const SizedBox(
                        height: 10,
                      ),
                      //input pour la classe

                      const SizedBox(
                        height: 15,
                      ),
                      input(professionController, (ecoleController) {
                        if (ecoleController!.isEmpty ||
                            ecoleController.length < 2) {
                          return 'Entrer une proffession';
                        } else {
                          return null;
                        }
                      },
                          false,
                          const Icon(Icons.school),
                          'profession ',
                          TextInputType.text,
                          "veuillez entrer votre profession"),
                      const SizedBox(
                        height: 15,
                      ),
                      input(passwordController, (passwordController) {
                        if (passwordController!.length < 6) {
                          return 'Le mot de passe doit avoir au moins 6 caractères';
                        } else {
                          return null;
                        }
                      },
                          true,
                          const Icon(Icons.lock),
                          'Votre mot de passe',
                          TextInputType.visiblePassword,
                          'veuillez entré le nom de votre ecole'),

                      const SizedBox(
                        height: 15,
                      ),

                      const Text(
                          "En vous inscrivant, vous acceptez la politique générale d'utilisation  et de vente de Monprof ",
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              value: politique,
                              onChanged: (pol) =>
                                  setState(() => politique = pol!)),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    alignment: Alignment.bottomCenter,
                                    type: PageTransitionType.rightToLeft,
                                    child: const ContratUser(),
                                  ),
                                );
                              },
                              child: const Text('Lire la politique...',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),

                      Visibility(
                        visible: politique,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          margin: const EdgeInsets.all(15),
                          child: TextButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = !isloading;
                                });

                                final parent = Parent(
                                    profession: professionController.text,
                                    nom: nomController.text,
                                    email: emailController.text,
                                    telephone: numeroController.text,
                                    sexe: valeursexe ?? "pas de sexe",
                                    idParent: '');

                                var dataIns = await parent
                                    .register(passwordController.text);
                                var idP = '';
                                if (dataIns != null) {
                                  for (var i = 0; i <= dataIns.length; i++) {
                                    if (dataIns[i].containsKey('id')) {
                                      setState(() {
                                        idP = dataIns[i]['id'] ?? '';
                                      });
                                      break;
                                    } else {
                                      continue;
                                    }
                                  }
                                  print(
                                      "$idP  l'id de l'eleve est dans la session");
                                  // eleve.idEleve = (result[0])['id'];
                                  // eleve.idclasse = Eleve.listclasse[eleve.classe];

                                  if (idP.trim().isEmpty) {
                                    print(idP);
                                    debugPrint("l'id du parent est nul");
                                  } else {
                                    parent.idParent = idP;
                                    Parent.saveParent(parent, idP);
                                  }
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      type: PageTransitionType.rightToLeft,
                                      child: const TransitionPage(),
                                    ),
                                  );
                                }
                                setState(() {
                                  isloading = !isloading;
                                });
                              } else {
                                null;
                              }
                            },
                            child: const Text(
                              "S'INSCRIRE",
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
