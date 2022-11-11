import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monprof/UI/sugestion.dart';
import 'package:monprof/back-end/modelparent.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/row_compte.dart';

class CompteP extends StatefulWidget {
  const CompteP({Key? key}) : super(key: key);

  @override
  State<CompteP> createState() => _ComptePState();
}

class _ComptePState extends State<CompteP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Compte')),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  rowCompte(Colors.blue, "Informations sur le compte",
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
                            children: [
                              const Text(
                                'Nom',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '${Parent.sessionParent.nom}',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '${Parent.sessionParent.email}',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Numéro',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '${Parent.sessionParent.telephone}',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                                  'https://web.facebook.com/?_rdc=1&_rdr'));
                              print('pass');
                            },
                            child: const CircleAvatar(
                                maxRadius: 20,
                                child: FaIcon(FontAwesomeIcons.facebookF)),
                          ),
                          InkWell(
                            onTap: () async {
                              await launchUrl(Uri.parse(
                                  'https://web.facebook.com/?_rdc=1&_rdr'));
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
                                  'https://web.facebook.com/?_rdc=1&_rdr'));
                              print('pass');
                            },
                            child: const CircleAvatar(
                                maxRadius: 20,
                                backgroundImage:
                                    AssetImage('assets/insta.png')),
                          ),
                          InkWell(
                            onTap: () async {
                              await launchUrl(Uri.parse(
                                  'https://web.facebook.com/?_rdc=1&_rdr'));
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Votre avis compte 😃",
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
                                    duration: const Duration(milliseconds: 300),
                                    type: PageTransitionType.bottomToTop,
                                    child: const Suggestion(),
                                  ));
                            },
                            child: const Text(
                              "Je donne mon avis",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
