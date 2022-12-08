import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:monprof/UI/active_compte.dart';
import 'package:monprof/back-end/api.dart';
import 'package:monprof/back-end/model.dart';
import 'package:monprof/components/row_compte.dart';
import 'package:url_launcher/url_launcher.dart';

class CompteUser extends StatefulWidget {
  const CompteUser({
    Key? key,
  }) : super(key: key);

  @override
  State<CompteUser> createState() => _CompteUserState();
}

late String nom;
late String telephone;
late String libelle;
late String etat;
bool actif = false;

class _CompteUserState extends State<CompteUser> {
  //la fonction categorieactiver a pour but de
  //recupéré tout les trimestre qu'a activer l'utilisateur

  List<Map<String, dynamic>> listcategorie = [];
  Future<List<Map<String, dynamic>>> categoriactiver() async {
    List<Map<String, dynamic>> liste = [];
    final uri = Uri(
        scheme: 'http',
        host: '$domain',
        port: port,
        path: '/monprof/web/consultation/categorieService.php',
        queryParameters: {
          "requete_type": '3',
          "id_eleve": Eleve.sessionEleve.idEleve,
        });
    //print(uri);
    var result = await http.get(uri);
    var data = jsonDecode(result.body);
    if (result.statusCode == 200) {
      for (var x in data) {
        liste.add({
          'id': x['id'],
          'libelle': x['libelle'],
          'description': x['description'],
          'statut': x["statut"],
        });
      }
      if (result.body.isNotEmpty) {
        print(result.body.toString());
      }
    }
    setState(() {
      listcategorie = liste;
    });
    return listcategorie;
  }

  @override
  void initState() {
    categoriactiver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compte'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              rowCompte(Colors.blue, "Informations sur le compte", Icons.info),
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          height: 100,
                          child: ClipOval(
                              child: Eleve.sessionEleve.sexe == 'HOMME'
                                  ? Image.asset('assets/study3.png')
                                  : Image.asset('assets/study4.png'))),
                      Column(
                        children: [
                          Text(
                            Eleve.sessionEleve.nom ?? "Error to get a name",
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            Eleve.sessionEleve.classe,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              rowCompte(Colors.blue, "Informations sur le statut du compte",
                  Icons.real_estate_agent),
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Statut du Compte',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            " Statut",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        child: Column(
                          children: listcategorie
                              .map(
                                (trim) => Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        trim['libelle'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 17),
                                      ),
                                      trim['statut'] == "1"
                                          ? const Icon(
                                              Icons.check_circle,
                                              color: Colors.greenAccent,
                                            )
                                          : const Icon(
                                              Icons.check_circle,
                                              color: Colors.red,
                                            )
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: const [
                      //     Text(
                      //       'Trimestre activer',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500, fontSize: 15),
                      //     ),
                      //     Text(
                      //       '//',
                      //       style: TextStyle(
                      //           fontSize: 17,
                      //           color: Colors.red,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const Text(
                        "Si vous disposez "
                        "d'un code d'activation, veuillez activer cet abonnement ",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 15),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ActiveCompte()),
                            );
                          },
                          child: const Text(
                            "Activer",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              rowCompte(Colors.blue, "Information sur l'application",
                  Icons.app_settings_alt_outlined),
              const SizedBox(
                height: 15,
              ),
              const Icon(
                Icons.school_outlined,
                size: 250,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'MonProf version 1.0',
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'http://web.facebook.com/?_rdc=1&_rdr'));
                          print('pass');
                        },
                        child: const CircleAvatar(
                            maxRadius: 20,
                            child: FaIcon(FontAwesomeIcons.facebookF)),
                      ),
                      InkWell(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'http://web.facebook.com/?_rdc=1&_rdr'));
                          print('pass');
                        },
                        child: const CircleAvatar(
                            maxRadius: 20,
                            backgroundColor: Colors.green,
                            child: FaIcon(
                              FontAwesomeIcons.globe,
                              color: Colors.white,
                            )),
                      ),
                      InkWell(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'http://web.facebook.com/?_rdc=1&_rdr'));
                          print('pass');
                        },
                        child: const CircleAvatar(
                            maxRadius: 20,
                            backgroundImage: AssetImage('assets/insta.png')),
                      ),
                      InkWell(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'http://web.facebook.com/?_rdc=1&_rdr'));
                          print('pass');
                        },
                        child: const CircleAvatar(
                            maxRadius: 20,
                            backgroundColor: Colors.blue,
                            child: FaIcon(
                              FontAwesomeIcons.twitter,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
