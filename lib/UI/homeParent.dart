import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monprof/UI/compteP.dart';
import 'package:monprof/UI/paiementparent.dart';
import 'package:monprof/back-end/api.dart';
import 'package:monprof/back-end/modelparent.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class HomeParent extends StatefulWidget {
  const HomeParent({Key? key}) : super(key: key);

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
// http://$domain/monprof/web/consultation/categorieService.php?requete_type=4&id_eleve=1
  Map<int, Color> colorstat = {
    0: const Color.fromARGB(255, 14, 102, 185),
    1: const Color.fromARGB(255, 65, 70, 65),
    2: const Color.fromARGB(255, 111, 51, 180),
    3: const Color.fromARGB(255, 92, 102, 73)
  };

  List<Map<String, dynamic>> listcategoriestat = [];
  Future<List<Map<String, dynamic>>> statistiques() async {
    List<Map<String, dynamic>> liste = [];
    final uri = Uri(
        scheme: 'http',
        host: '$domain',
        path: '/monprof/web/consultation/categorieService.php',
        queryParameters: {
          "requete_type": '4',
          "id_eleve": Parent.sessionParent.idParent,
        });
    //print(uri);
    var result = await http.get(uri);
    var data = jsonDecode(result.body);
    if (result.statusCode == 200) {
      int i = 0;
      for (var x in data) {
        liste.add({
          'id': x['id'],
          'libelle': x['libelle'],
          'description': x['description'],
          'statut': x["statut"],
          'nbreTotal': x['nbreTotal'],
          'nbreTotalActive': x['nbreTotalActive'],
          "colors": i,
        });
        i++;
      }
      if (result.body.isNotEmpty) {
        print(result.body.toString());
      }
    }
    setState(() {
      listcategoriestat = liste;
    });
    return listcategoriestat;
  }

  @override
  void initState() {
    statistiques();
    super.initState();
  }

  void press() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("MonProf"),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          alignment: Alignment.bottomCenter,
                          type: PageTransitionType.rightToLeft,
                          child: const CompteP(),
                        ));
                  },
                  child: Parent.sessionParent.sexe == 'HOMME'
                      ? const CircleAvatar(
                          minRadius: 20,
                          backgroundImage: AssetImage('assets/Homme.png'),
                        )
                      : const CircleAvatar(
                          minRadius: 20,
                          backgroundImage: AssetImage('assets/Femme.png'),
                        )),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () async {
            statistiques();
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child: Image.asset('assets/mp2.png')),
                const SizedBox(
                  height: 30,
                ),
                // boutton(context, 'acheter', press, 250, 20),
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 2,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.blue)),
                        child: TextButton(
                          child: const Text(
                            'Faire un achat',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () => Navigator.of(context).push(
                              PageTransition(
                                  child: const Paiementparent(),
                                  type: PageTransitionType.leftToRight)),
                        )),
                  ),
                ),
                const Text('statuts',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400)),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  height: 400,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Wrap(
                      children: listcategoriestat
                          .map((data) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                                color:
                                                    colorstat[data['colors']],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: [
                                                Text(data['libelle'],
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const Divider(
                                                  thickness: 3,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Total',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300)),
                                                    Text(
                                                        data['nbreTotal']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Activer',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300)),
                                                    Text(
                                                        data['nbreTotalActive']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 2,
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Text(
                                                      data['nbreTotal']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17)),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('libelle'),
                                      //     Text(data['libelle']),
                                      //   ],
                                      // ),
                                      // Text(data['description']),
                                      // Text(data['statut']),
                                      // Text(data['nbreTotal'].toString()),
                                      // Text(
                                      //     data['nbreTotalActive'].toString()),
                                    ]),
                              ))
                          .toList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
