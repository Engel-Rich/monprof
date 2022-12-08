import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monprof/UI/sugestion.dart';
import 'package:monprof/UI/videocours.dart';
import 'package:monprof/back-end/api.dart';
import 'package:monprof/back-end/model.dart';
import 'package:monprof/components/bouton.dart';
import 'package:page_transition/page_transition.dart';

import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import 'compte.dart';

class Home extends StatefulWidget {
  final Eleve eleve;
  final VoidCallback logou;
  const Home({Key? key, required this.eleve, required this.logou})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? dropdownValue;
  String? trimestre;
  String? matiere;
  String prixMat = "";
  var listtrim = <Map<String, String>>[];
  var listmat = <Map<String, String>>[];
  List listtrimDow = [];
  List listmatDow = [];

  // la fonction listrimestre a pour but
  //le listé les trimestre depuis le server
  Future<void> listtrimestre() async {
    var list = <String>[];
    final url = Uri.parse(
        'http://$domain:$port/monprof/web/consultation/categorieService.php?requete_type=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final listProvisoire = jsonDecode(response.body);
        for (var x in listProvisoire) {
          list.add(x['libelle']);
          listtrim.add({
            x['libelle']: x['id'],
          });
        }
      }
    } else {
      list.add(response.statusCode.toString());
    }
    setState(() {
      listtrimDow = list;
    });
  }

//  la fonction listematiere a pour but de
//   listé les matieres depuis le serveur   http:/$domainmonprof/web/consultation/matiereService.php?requete_type=1&id_classe=4
  //http://$domain/monprof/web/consultation/matiereService.php?requete_type=1&id_classe=1
  Future<void> listmatiere() async {
    var list = <String>[];
    final url = Uri(
        scheme: 'http',
        host: '$domain',
        port: port,
        path: 'monprof/web/consultation/matiereService.php',
        queryParameters: {
          'requete_type': '1',
          'id_classe': Eleve.sessionEleve.idc,
        });
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final listProvisoire = jsonDecode(response.body);
        for (var x in listProvisoire) {
          list.add(x['libelle']);
          listmat.add({
            x['libelle']: x['id'],
          });
        }
      }
    } else {
      list.add(response.statusCode.toString());
    }
    setState(() {
      listmatDow = list;
    });
  }

  // Future<List<String>> listscours() async {
  //   var listescours = <String>[];

  //   return listescours;
  // }

  // la fonction  nav a pour but de recuperé la matiere et le trimestre choisi
  //puis faire passé ses valeurs a la route
  void nav() {
    var idtrim = '';
    var idmat = '';
    var libmat = '';
    var libtrim = '';
    if (matiere != null && trimestre != null) {
      for (var i = 0; i <= listmat.length; i++) {
        if (listmat[i].containsKey(matiere)) {
          setState(() {
            idmat = listmat[i][matiere] ?? '';
          });
          break;
        } else {
          continue;
        }
      }
      for (var i = 0; i <= listtrim.length; i++) {
        if (listtrim[i].containsKey(trimestre)) {
          setState(() {
            idtrim = listtrim[i][trimestre] ?? '';
          });
          break;
        } else {
          continue;
        }
      }
      for (var i = 0; i <= listmat.length; i++) {
        if (listmat[i].containsKey(matiere)) {
          setState(() {
            libmat = matiere ?? ' ';
          });
          break;
        } else {
          continue;
        }
      }
      for (var i = 0; i <= listtrim.length; i++) {
        if (listtrim[i].containsKey(trimestre)) {
          setState(() {
            libtrim = trimestre ?? '';
          });
          break;
        } else {
          continue;
        }
      }

      Navigator.push(
          context,
          PageTransition(
            alignment: Alignment.bottomCenter,
            type: PageTransitionType.rightToLeft,
            child: Cours(
                idmat: idmat, idtrim: idtrim, libmat: libmat, libtrim: libtrim),
          ));
    } else {
      Fluttertoast.showToast(
        msg: 'veuillez choisir la classe et la matiere',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue.shade400.withOpacity(0.9),
        timeInSecForIosWeb: 4,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    listtrimestre();
    listmatiere();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("MonProf"),
        elevation: 0,
        actions: [
          Container(
              margin: const EdgeInsets.all(5),
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(Eleve.sessionEleve.classe,
                    style: const TextStyle(fontSize: 15)),
              )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        PageTransition(
                          alignment: Alignment.bottomCenter,
                          type: PageTransitionType.rightToLeft,
                          child: const CompteUser(),
                        ));
                  },
                  child: Image.asset('assets/study2.png')),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(child: Image.asset('assets/mp2.png')),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: listtrimDow.isNotEmpty
                      ? DropdownButton<String>(
                          value: trimestre,
                          borderRadius: BorderRadius.circular(10),
                          alignment: AlignmentDirectional.centerStart,

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
                          onChanged: (String? newValue) {
                            setState(() {
                              trimestre = newValue;
                            });
                          },
                          items: listtrimDow.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: const Text(
                            "Choisir le trimestre",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Shimmer.fromColors(
                          period: const Duration(milliseconds: 500),
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: listtrimDow.isNotEmpty
                      ? DropdownButton<String>(
                          value: matiere,
                          borderRadius: BorderRadius.circular(10),
                          alignment: AlignmentDirectional.centerStart,

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
                          onChanged: (String? newValue) {
                            setState(() {
                              matiere = newValue;
                            });
                          },
                          items: listmatDow.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: const Text(
                            "Choisir la matière",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Shimmer.fromColors(
                          period: const Duration(milliseconds: 500),
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
                //   width: MediaQuery.of(context).size.width * 0.7,
                //   padding: const EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //     color: Colors.blue.withOpacity(0.3),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   //reduire la taille du composant
                //   child: DropdownButton<String>(
                //     value: trimestre,
                //     borderRadius: BorderRadius.circular(10),
                //     alignment: AlignmentDirectional.centerStart,

                //     isExpanded: true,
                //     iconEnabledColor: Colors.black,
                //     iconSize: 30,
                //     elevation: 16,
                //     //style: TextStyle(color: Colors.teal),
                //     underline: Container(
                //       decoration: const BoxDecoration(
                //         color: Colors.black,
                //       ),
                //     ),
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         trimestre = newValue;
                //       });
                //     },
                //     items: <String>[
                //       'Trimestre1',
                //       'Trimestre2',
                //       'Trimestre3',
                //       'Examen',
                //     ].map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //     hint: const Text(
                //       "Choisir le trimestre",
                //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                //     ),
                //   ),
                // ),

                const SizedBox(
                  height: 15,
                ),
                boutton(context, 'Rechercher', nav, 250, 17),
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Votre avis compte 😃 ",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                type: PageTransitionType.bottomToTop,
                                child: const Suggestion(),
                              ));
                        },
                        child: const Text(
                          "Je donne mon avis",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
