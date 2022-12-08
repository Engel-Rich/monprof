import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monprof/UI/homeParent.dart';
import 'package:http/http.dart' as http;
import 'package:monprof/back-end/api.dart';
import 'package:monprof/back-end/modelparent.dart';
import 'package:monprof/components/input2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import '../components/row_compte.dart';

class Paiementparent extends StatefulWidget {
  const Paiementparent({
    Key? key,
  }) : super(key: key);

  @override
  State<Paiementparent> createState() => _PaiementparentState();
}

final numDebitController = TextEditingController();
final numCreditController = TextEditingController();
final quantiteController = TextEditingController();
final key = GlobalKey<FormState>();
bool isloading = false;

class _PaiementparentState extends State<Paiementparent> {
  Map<String, dynamic>? trimestre;
  String? classe;
  String? matiere;
  Map<String, dynamic>? valeurClasse;
  String? quantite;
  var quantiteCours = 1;
  // http://$domain/monprof/web/consultation/paiementAttenteService.php?requete_type=1&id_categorie=1&id_classe=1&id_eleve=1&numero_debite=657140696&numero_credite=657140696&quantite=45
  Future<String?> paiementP(
      String numDebit, String numCredit, String quantite) async {
    try {
      // final uri = Uri.parse(
      //     'http://$domain/monprof/web/consultation/paiementAttenteService.php?requete_type=1&id_categorie=$trim&id_classe=$idClasse&id_eleve=${Parent.sessionParent.idParent}&numero_debite=$numDebit&numero_credite=$numCredit&quantite=$quantite');
      final uri = Uri(
        scheme: 'http',
        port: port,
        host: '$domain',
        path: '/monprof/web/consultation/paiementAttenteService.php',
      );
      print('la valeur du URI ' + uri.toString());
      final result = await http.post(uri,
          body: jsonEncode({
            "requete_type": '1',
            "id_categorie": trim,
            "id_classe": idClasse,
            "id_eleve": Parent.sessionParent.idParent,
            "numero_debite": numDebit,
            "numero_credite": numCredit,
            "quantite": quantite,
          }));
      print(result.statusCode);
      if (result.statusCode == 200) {
        print('ca c est le body' + result.body.toString());
        return null;
      } else {
        return 'erreur';
      }
    } catch (e) {
      print('erreur de URI ' + e.toString());
      return "erreur";
    }
  }

  // Future<void> listmatiere() async {
  //   var list = <String>[];
  //   final url = Uri(
  //       scheme: 'http',
  //       host: '$domain',
  //       path: 'monprof/web/consultation/matiereService.php',
  //       queryParameters: {
  //         'requete_type': '1',
  //         'id_classe': "1",
  //       });
  //   print(url);
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     if (response.body.isNotEmpty) {
  //       final listProvisoire = jsonDecode(response.body);
  //       for (var x in listProvisoire) {
  //         list.add(x['libelle']);
  //         listmat.add({
  //           x['libelle']: x['id'],
  //         });
  //       }
  //     }
  //   } else {
  //     list.add(response.statusCode.toString());
  //   }
  //   setState(() {
  //     listmatDow = list;
  //   });
  // }

  getidCours() {}
  bool visible = false;
  bool visibleconfir = true;
  String requestError = '';
  late List<Map<String, String>> courliste = [];
  var listCoursDropdown = <Map<String, dynamic>>[];
  late Map<String, String> dataIns;
  Future<void> listcours() async {
    var list = <Map<String, String>>[];
    final url = Uri.parse(
        'http://$domain:$port/monprof/web/consultation/classeService.php?requete_type=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final listProvisoire = json.decode(response.body);

        //final listProvisoire = jsonDecode(response.body);

        for (var x in listProvisoire) {
          list.add({x['libelle'].toString(): x['id'].toString()});

          listCoursDropdown.add(
              {'libelle': x['libelle'].toString(), 'id': x['id'].toString()});
        }
        print('La liste des classes est : $listCoursDropdown');
      }
    } else {
      list.add({
        'code': response.statusCode.toString(),
      });
    }
    setState(() {
      courliste = list;
    });
  }

  var listtrim = <Map<String, String>>[];
  var listmat = <Map<String, String>>[];
  List<Map<String, dynamic>> listtrimDow = [];
  List listmatDow = [];
  void navp() {
    for (var i = 0; i <= listmat.length; i++) {
      if (listmat[i].containsKey(matiere)) {
        setState(() {
          idClasse = (listmat[i][matiere] ?? '') as int;
        });
        break;
      } else {
        continue;
      }
    }
    for (var i = 0; i <= listtrim.length; i++) {
      if (listtrim[i].containsKey(trimestre)) {
        setState(() {
          trim = (listtrim[i][trimestre] ?? '') as int;
        });
        break;
      } else {
        continue;
      }
    }
  }

  // la fonction listrimestre a pour but
  //le listé les trimestre depuis le server
  Future<void> listtrimestre() async {
    List<Map<String, dynamic>> list = [];
    final url = Uri.parse(
        'http://$domain:$port/monprof/web/consultation/categorieService.php?requete_type=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final listProvisoire = jsonDecode(response.body);
        for (var x in listProvisoire) {
          listtrimDow.add({
            'libelle': x['libelle'],
            'id': x['id'],
          });
          listtrim.add({
            'libelle': x['libelle'],
            'id': x['id'],
          });
        }
      }
    } else {
      list.add({'code :': response.statusCode.toString()});
    }
    // setState(() {
    //   listtrimDow = list;
    // });
  }

  @override
  // void initState() {
  //   super.initState();
  //   listcours();
  //   setState(() {
  //     courliste;
  //   });
  //   // print(listcours());
  // }
  late int idClasse;
  late int trim;
  double prix = 0;
  double montantTotal = 0;
  void montant() async {
    if (trim != null && idClasse != null) {
      print('les valeurs sont : + $trim, $idClasse');
      print('les id des classe sont');
      print('un autre ways ');
      var urli =
          "http://$domain:$port/monprof/web/consultation/categorieService.php?requete_type=5&id_categorie=$trim&id_classe=$idClasse";
      final url = Uri.parse(urli);
      // Uri(
      //     scheme: 'http',
      //     host: '$domain',
      //     path: '/monprof/web/consultation/categorieService.php',
      //     queryParameters: {
      //       "requete_type": '5',
      //       'id_categorie': 1,
      //       'id_classe': 1,
      //     });
      print(url);
      final response = await http.post(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('le prix recu est :' + data.toString());
        setState(() {
          prix = data;
          montantTotal = prix * quantiteCours;
        });
      } else {
        print('erreur' + response.statusCode.toString());
      }
    } else {
      print('valeur vide');
    }
  }

  void initState() {
    super.initState();
    listtrimestre();
    listcours();
    // montant();
    setState(() {
      courliste;
    });
  }

  void Sendverify(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromARGB(0, 190, 36, 36),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Paiement d'un abonnement"),
        ),
        body: isloading
            ? Center(
                child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ))
            : Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: key,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rowCompte(Colors.blue, "Informations sur la classe",
                            Icons.school),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    //width: MediaQuery.of(context).size.width * 0.7,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: listCoursDropdown.isNotEmpty
                                        ? DropdownButton<Map<String, dynamic>>(
                                            value: valeurClasse,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            isExpanded: true,
                                            iconEnabledColor: Colors.black,
                                            iconSize: 30,
                                            elevation: 16,
                                            underline: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onChanged: (newValue) {
                                              setState(() {
                                                valeurClasse = newValue!;
                                                idClasse =
                                                    int.parse(newValue['id']);
                                              });
                                              montant();
                                              setState(() {});

                                              Fluttertoast.showToast(
                                                msg:
                                                    'Vous avez choisi la classe de: ${valeurClasse!['libelle']}',
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                            249, 20, 185, 136)
                                                        .withOpacity(0.9),
                                                timeInSecForIosWeb: 5,
                                              );
                                            },
                                            items:
                                                listCoursDropdown.map((value) {
                                              return DropdownMenuItem<
                                                  Map<String, dynamic>>(
                                                value: value,
                                                child: Text(value['libelle']),
                                              );
                                            }).toList(),
                                            hint: const Text(
                                              "Choisir la classe",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : Shimmer.fromColors(
                                            period: const Duration(
                                                milliseconds: 500),
                                            child: Container(
                                              margin: const EdgeInsets.all(0.0),
                                              height: 50,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              width: double.infinity,
                                              child: const Center(
                                                child: Text(
                                                    'selectionner la classe'),
                                              ),
                                            ),
                                            baseColor: Colors.grey.shade400,
                                            highlightColor:
                                                Colors.grey.shade200,
                                          )),
                                // Container(
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.8,
                                //     padding: const EdgeInsets.all(5),
                                //     decoration: BoxDecoration(
                                //       color: Colors.blue.withOpacity(0.3),
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     child: listtrimDow.isNotEmpty
                                //         ? DropdownButton<String>(
                                //             value: trimestre,
                                //             borderRadius:
                                //                 BorderRadius.circular(10),
                                //             alignment:
                                //                 AlignmentDirectional.centerStart,

                                //             isExpanded: true,
                                //             iconEnabledColor: Colors.black,
                                //             iconSize: 30,
                                //             elevation: 16,
                                //             //style: TextStyle(color: Colors.teal),
                                //             underline: Container(
                                //               decoration: const BoxDecoration(
                                //                 color: Colors.black,
                                //               ),
                                //             ),
                                //             onChanged: (String? newValue) {
                                //               setState(() {
                                //                 trimestre = newValue;
                                //               });
                                //             },
                                //             items: listtrimDow.map((value) {
                                //               return DropdownMenuItem<String>(
                                //                 value: value,
                                //                 child: Text(value),
                                //               );
                                //             }).toList(),
                                //             hint: const Text(
                                //               "Choisir le trimestre",
                                //               style: TextStyle(
                                //                   fontSize: 16,
                                //                   fontWeight: FontWeight.w500),
                                //             ),
                                //           )
                                //         : Shimmer.fromColors(
                                //             period:
                                //                 const Duration(milliseconds: 500),
                                //             child: Container(
                                //               margin: const EdgeInsets.all(0.0),
                                //               height: 50,
                                //               color: Colors.grey.withOpacity(0.5),
                                //               width: double.infinity,
                                //               child: const Center(
                                //                 child: Text('patientez svp'),
                                //               ),
                                //             ),
                                //             baseColor: Colors.grey.shade400,
                                //             highlightColor: Colors.grey.shade200,
                                //           ),
                                //   ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: listtrimDow.isNotEmpty
                                      ? DropdownButton<Map<String, dynamic>>(
                                          value: trimestre,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          alignment:
                                              AlignmentDirectional.centerStart,

                                          isExpanded: true,
                                          iconEnabledColor: Colors.black,
                                          iconSize: 30,
                                          elevation: 16,
                                          //style: TextStyle(color: Colors.teal),
                                          underline: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              trimestre = newValue;
                                              trim = int.parse(newValue?['id']);
                                            });
                                            montant();
                                            setState(() {});
                                          },
                                          items: listtrimDow.map((value) {
                                            return DropdownMenuItem<
                                                Map<String, dynamic>>(
                                              value: value,
                                              child: Text(value['libelle']),
                                            );
                                          }).toList(),
                                          hint: const Text(
                                            "Choisir le trimestre",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      : Shimmer.fromColors(
                                          period:
                                              const Duration(milliseconds: 500),
                                          child: Container(
                                            margin: const EdgeInsets.all(0.0),
                                            height: 50,
                                            color: Colors.grey.withOpacity(0.5),
                                            width: double.infinity,
                                            child: const Center(
                                              child: Text('patientez svp'),
                                            ),
                                          ),
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.grey.shade200,
                                        ),
                                ),
                                // Container(
                                //   // width:
                                //   //  MediaQuery.of(context).size.width * 0.7,
                                //   padding: const EdgeInsets.all(5),
                                //   decoration: BoxDecoration(
                                //     color: Colors.blue.withOpacity(0.3),
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: listtrimDow.isNotEmpty
                                //       ? DropdownButton<String>(
                                //           value: trimestre,
                                //           borderRadius:
                                //               BorderRadius.circular(10),
                                //           alignment:
                                //               AlignmentDirectional.centerStart,

                                //           isExpanded: true,
                                //           iconEnabledColor: Colors.black,
                                //           iconSize: 30,
                                //           elevation: 16,
                                //           //style: TextStyle(color: Colors.teal),
                                //           underline: Container(
                                //             decoration: const BoxDecoration(
                                //               color: Colors.black,
                                //             ),
                                //           ),
                                //           onChanged: (String? newValue) {
                                //             setState(() {
                                //               trimestre = newValue;
                                //             });
                                //           },
                                //           items: listtrimDow.map((value) {
                                //             return DropdownMenuItem<String>(
                                //               value: value,
                                //               child: Text(value),
                                //             );
                                //           }).toList(),
                                //           hint: const Text(
                                //             "Choisir le trimestre",
                                //             style: TextStyle(
                                //                 fontSize: 16,
                                //                 fontWeight: FontWeight.w500),
                                //           ),
                                //         )
                                //       : Shimmer.fromColors(
                                //           period:
                                //               const Duration(milliseconds: 500),
                                //           child: Container(
                                //             margin: const EdgeInsets.all(0.0),
                                //             height: 50,
                                //             color: Colors.grey.withOpacity(0.5),
                                //             width: double.infinity,
                                //             child: const Center(
                                //               child: Text('patientez svp'),
                                //             ),
                                //           ),
                                //           baseColor: Colors.grey.shade400,
                                //           highlightColor: Colors.grey.shade200,
                                //         ),
                                // ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(99, 163, 163, 163),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text('$prix' + 'Fcfa',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: Colors.green))),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: quantiteController,
                                    onChanged: (val) {
                                      if (val.trim().isNotEmpty) {
                                        setState(() {
                                          quantiteCours = int.parse(val);
                                          montantTotal = prix * quantiteCours;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.blue.withOpacity(0.3),
                                      filled: true,
                                      hintText: 'Quantité',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    )),
                                // input(quantiteController, (value) {
                                //   if (value!.length < 9 || value.length > 10) {
                                //     return 'entrez un numéro valide';
                                //   } else {
                                //     return null;
                                //   }
                                // }, true, const Icon(Icons.ac_unit), 'Quantité',
                                //     TextInputType.number, 'nombre invalide'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(99, 163, 163, 163),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '$montantTotal' + 'Fcfa',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        rowCompte(Colors.blue, "Informations sur le contact",
                            Icons.phone_android_outlined),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Numéro qui recevra le SMS',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                input2(numDebitController, (value) {
                                  if (value!.length != 9) {
                                    return 'Entrer un numéro valide';
                                  } else {
                                    return null;
                                  }
                                },
                                    'Numéro du bénéficiaire',
                                    'Numéro du bénéficiaire',
                                    'Entrer un numéro valide'),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'Numéro du payeur',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                input2(numCreditController, (value) {
                                  if (value!.length != 9) {
                                    return 'Entrer le numéro à débiter';
                                  } else {
                                    return null;
                                  }
                                }, 'Numéro à déditer', 'Numéro à débiter',
                                    'Entrer un numéro valide'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        rowCompte(
                            Colors.blue,
                            "Information sur le mode de paiement",
                            Icons.wallet_giftcard),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        height: 50,
                                        child:
                                            Image.asset('assets/orange.png')),
                                    const Text(
                                      '#150*11*MONPROF*Montant#',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        height: 45,
                                        child: Image.asset('assets/momo.jpg')),
                                    const Text(
                                      ' 657 140 696',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text('Nom affiché : ETS MONPROF',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Column(
                          children: const [
                            Text(
                              'Veuiller initier le paiement avec la chaine de paiement correspondante à votre opérateur.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Vous allez recevoir un sms dans moins de 24h pour activer votre abonnement.',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          margin: const EdgeInsets.all(15),
                          child: TextButton(
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                var numdebit = numDebitController.text;
                                var numCredit = numCreditController.text;
                                var quantite = quantiteController.text;
                                final res = await paiementP(
                                    numdebit, numCredit, quantite);
                                if (res == null) {
                                  Fluttertoast.showToast(
                                    msg: 'commande valider avec succes',
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor:
                                        Colors.blue.shade400.withOpacity(0.9),
                                    timeInSecForIosWeb: 4,
                                  );
                                  Navigator.pop(context);
                                  // context,
                                  // PageTransition(
                                  //   alignment: Alignment.bottomCenter,
                                  //   type: PageTransitionType.rightToLeft,
                                  //   child: const HomeParent(),
                                  // ));
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Erreur',
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor:
                                        Colors.red.shade400.withOpacity(0.9),
                                    timeInSecForIosWeb: 10,
                                  );
                                }

                                setState(() {
                                  isloading = false;
                                });
                              } else {
                                null;
                              }
                            },
                            child: const Text(
                              "Valider ma commande",
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
              ));
  }
}
