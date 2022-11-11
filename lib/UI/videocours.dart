import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:monprof/UI/compte.dart';
import 'package:monprof/UI/lecteurvideo.dart';

import 'package:monprof/UI/login.dart';
import 'package:monprof/UI/paiement.dart';
import 'package:monprof/UI/pieceJointe.dart';
import 'package:monprof/UI/question.dart';
import 'package:monprof/UI/waitPage.dart';
import 'package:monprof/back-end/api.dart';
import 'package:monprof/back-end/model.dart';
import 'package:monprof/components/bouton.dart';
import 'package:monprof/components/input.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../back-end/booltransform.dart';

class Cours extends StatefulWidget {
  final String idmat;
  final String idtrim;
  final String libmat;
  final String libtrim;

  const Cours({
    Key? key,
    required this.idmat,
    required this.libmat,
    required this.libtrim,
    required this.idtrim,
  }) : super(key: key);

  @override
  _CoursState createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  // ignore: prefer_typing_uninitialized_variables
  var tabController;
  int indextab = 0;
  final title = TextEditingController();
  final desc = TextEditingController();
  //late TabController _controller;
  int _currentIndex = 0;
  var listcourvide = true;

  String prixMat = '';
  var downloadIndex = -1;
  var key = GlobalKey<FormState>();
  final Dio dio = Dio();
  bool expan = false;
  // with SingleTickerProviderStateMixin
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TabController(vsync: this, length: 2);
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  //   List<Map<String, dynamic>> listCours = [];
  // final String host = '';
  // Future<void> getCoursList() async {
  //   final url = Uri(
  //       scheme: "http",
  //       host: host,
  //       path: "",
  //       queryParameters: {
  //         'matiere': ,
  //         "classe": ,
  //       });
  //   debugPrint(url.toString());
  //   final response = await get(url);
  //   if (response.statusCode == 200) {
  //     for (var video in jsonDecode(response.body)) {
  //       setState(() {
  //         listCours.add({
  //           "videos": video['video'].toString(),
  //           "titre": video['titre'].toString(),
  //         });
  //       });
  //     }
  //   } else {
  //     debugPrint(response.reasonPhrase);
  //   }
  // } list

  // =1&id_categorie=#id_categorie#&id_classe=#id_classe#&id_matiere=#id_matiere#
  // http://$domain/monprof/web/consultation/videoService.php?requete_type=1&id_categorie=#id_categorie#&id_classe=#id_classe#&id_matiere=#id_matiere#
  void change(String prix) {
    Navigator.push(
        context,
        PageTransition(
            alignment: Alignment.bottomCenter,
            type: PageTransitionType.rightToLeft,
            child: Paiement(
              libtrim: widget.libtrim,
              idtrim: widget.idtrim,
              prixMat: prix,
            ),
            fullscreenDialog: true));
  }

  List<Map<String, dynamic>> listcour = [];
  // la fonction listcourbuilder a pour but de listés tous les cours
  Future<void> listcourBuilder() async {
    List<Map<String, dynamic>> list = [];
    final url = Uri(
        scheme: 'http',
        host: '$domain',
        path: 'monprof/web/consultation/videoService.php',
        queryParameters: {
          "requete_type": '1',
          'id_eleve': Eleve.sessionEleve.idEleve,
          'id_categorie': widget.idtrim,
          'id_classe': Eleve.idClasse,
          'id_matiere': widget.idmat,
        });
    //print("l'url est : " + url.toString());
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint("les datas reçus :" + data.toString());
      for (var x in data) {
        list.add({
          'id': x['id'],
          'libelle': x['libelle'],
          'description': x['description'],
          'type': x['type'],
          'montant': x['montant'],
          'file_name': x['file_name'],
          'name': x['file_name'],
        });
      }
    }
    setState(() {
      listcour = list;
      listcourvide = false;
    });
  }

  // function pour tester l'existance d'un fichier
  Future<bool> existe(String namecours) async {
    directory = await getExternalStorageDirectory();
    final name = directory!.path + "/$namecours";
    final file = File(name);
    if (file.existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  //fonction pour l'envoie de message dans le forum
  List<Map<String, dynamic>> listsujetfinal = [];
  Future<void> ajoutsujet(String desc, String title) async {
    List<Map<String, dynamic>> listsujet = [];
    final url = Uri(
        scheme: 'http',
        host: '$domain',
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
    print(url.toString());
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
//http:$domain/monprof/web/consultation/sujetService.php?requete_type=2&id_categorie=1&id_matiere=2&id_classe=1
        path: 'monprof/web/consultation/sujetService.php',
        queryParameters: {
          "requete_type": '2',
          'id_categorie': widget.idtrim,
          'id_matiere': widget.idmat,
          'id_classe': Eleve.idClasse,
          'id_eleve': Eleve.sessionEleve.idEleve,
        });
    // print(url);
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
          "montant": x["montant"],
        });
      }
    }
    setState(() {
      listemessage = listmes;
    });
    print(url);
    return listemessage;
  }

  //fonction du bouton de submission qui
  //permet de valider et executé les fonctions
  //de recupération des sujets et submition des sujets
  bool char = false;
  valid() async {
    if (key.currentState!.validate()) {
      setState(() {
        char = true;
      });
      var resultat = await ajoutsujet(desc.text, title.text);
      var listeM = await recuplistesujets(desc.text, title.text);
      setState(() {
        char = false;
      });
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Votre question a été soumise avec succes',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue.shade400.withOpacity(0.9),
        timeInSecForIosWeb: 4,
      );
    } else {
      // print('la fonction ne s execute pas');
    }
  }

  //fonction pour sauvegarder les video et lire depuis le dossier de l'app
  bool loading = false;
  double progress = 0;
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  //fonction de suppression de vidéo mal télécharger ou avec erreur de lecture
  Future<bool> supprimer(String url, String fileName) async {
    Directory? dir = await getExternalStorageDirectory();
    //final targetFile = Directory("${dir.path}/books/$fileName.pdf");
    File targetFile = File(dir!.path + "/$fileName");
    if (targetFile.existsSync()) {
      targetFile.deleteSync(recursive: true);
      print('fichier supprimer avec succes:');
      return true;
    } else {
      return false;
    }
  }

  Directory? directory;
  Future<bool> saveVideo(String url, String fileName) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();

          // print(directory);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory!.exists()) {
        await directory!.create(recursive: true);
      }
      if (await directory!.exists()) {
        File saveFile = File(directory!.path + "/$fileName");
        if (await saveFile.exists()) {
          Navigator.push(
            context,
            PageTransition(
              alignment: Alignment.bottomCenter,
              type: PageTransitionType.rightToLeft,
              child: LectureCoursVideo(video: saveFile),
            ),
          );
          return false;
        } else {
          await dio.download(url, saveFile.path,
              onReceiveProgress: (value1, value2) {
            setState(() {
              progress = value1 / value2;
            });
            // print(progress);
          });
        }

        if (Platform.isIOS) {
          return false;
        }
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  downloadvideo(String url, String name) async {
    bool downloaded = await saveVideo(url, name);
    if (downloaded) {
      print("vidéo télécharger");
      Fluttertoast.showToast(
        msg: 'téléchargement terminé avec succes',
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.blue.shade400.withOpacity(0.9),
      );
    } else {
      print("echec de téléchargement");
    }
    setState(() {
      loading = false;
      progress = 0;
      downloadIndex = -1;
    });
  }

  @override
  void initState() {
    super.initState();
    listcourBuilder();
    recuplistesujets(desc.text, title.text);

    // debugPrint(listcour.toString());
    //print(listemessage);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(
        //     Icons.search,
        //   ),
        //   onPressed: () {},
        // ),
        appBar: AppBar(
          title: Text(widget.libmat),
          bottom: TabBar(
            onTap: (value) {
              setState(() {
                indextab = value;
              });
              print(indextab);
            },
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                icon: Icon(Icons.book),
                text: 'Exercices/Sujets',
              ),
              Tab(
                icon: Icon(Icons.message),
                text: 'Forum',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            listcourvide
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await listcourBuilder();
                        setState(() {});
                      },
                      child: ListView.builder(
                          itemCount: listcour.length,
                          itemBuilder: (context, index) {
                            String statut = listcour[index]['type'].toString();
                            String url =
                                listcour[index]['file_name'].toString();
                            String namecours =
                                listcour[index]['name'].toString();

                            return Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: Colors.blue),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: FutureBuilder<bool>(
                                        future: existe(namecours),
                                        builder: (context, snapshot) {
                                          return CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: (snapshot.hasData &&
                                                    snapshot.data! &&
                                                    (!loading &&
                                                        downloadIndex != index))
                                                ? const Icon(Icons.play_circle,
                                                    color: Colors.white)
                                                : (!loading &&
                                                        downloadIndex != index)
                                                    ? const Icon(Icons.download,
                                                        color: Colors.white)
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: progress,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                          );
                                        }),
                                    title: Text(listcour[index]['libelle']),
                                    subtitle:
                                        Text(listcour[index]['description']),
                                    trailing: Container(
                                      child: statut == '1'
                                          ? const Icon(Icons.lock)
                                          : PopupMenuButton(
                                              itemBuilder: ((context) => [
                                                    PopupMenuItem(
                                                        child: const Text(
                                                            'retélécharger'),
                                                        onTap: () async {
                                                          setState(() {
                                                            downloadIndex =
                                                                index;
                                                          });

                                                          var result =
                                                              await supprimer(
                                                                  url,
                                                                  namecours);
                                                          if (result) {
                                                            downloadvideo(
                                                                url, namecours);
                                                          } else if (!result) {
                                                            downloadvideo(
                                                                url, namecours);
                                                          } else {
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  'une erreur est survenue',
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              backgroundColor:
                                                                  Colors.red
                                                                      .shade400
                                                                      .withOpacity(
                                                                          0.9),
                                                              timeInSecForIosWeb:
                                                                  4,
                                                            );
                                                          }
                                                          // setState(() {
                                                          //   loading = false;
                                                          // });
                                                        }),
                                                    PopupMenuItem(
                                                        child: const Text(
                                                            'Supprimer'),
                                                        onTap: () async {
                                                          var result =
                                                              await supprimer(
                                                                  url,
                                                                  namecours);
                                                          if (result) {
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  'vidéo supprimer avec succes',
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              backgroundColor:
                                                                  Colors.blue
                                                                      .shade400
                                                                      .withOpacity(
                                                                          0.9),
                                                              timeInSecForIosWeb:
                                                                  4,
                                                            );
                                                          } else {
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "la video n'existe pas ",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              backgroundColor:
                                                                  const Color.fromARGB(
                                                                          255,
                                                                          248,
                                                                          108,
                                                                          120)
                                                                      .withOpacity(
                                                                          0.9),
                                                              timeInSecForIosWeb:
                                                                  4,
                                                            );
                                                          }
                                                        }),
                                                  ])),
                                    ),
                                    onTap: () {
                                      // int vidname =
                                      //     DateTime.now().microsecondsSinceEpoch;
                                      if (statut != '1') {
                                        downloadIndex = index;
                                      }
                                      // index = index;
                                      setState(() {});

                                      print('l indexe est' +
                                          downloadIndex.toString());

                                      statut == '1'
                                          ? Navigator.push(
                                              context,
                                              PageTransition(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                curve: Curves.easeInOut,
                                                type: PageTransitionType
                                                    .leftToRight,
                                                child: Paiement(
                                                  libtrim: widget.libtrim,
                                                  idtrim: widget.idtrim,
                                                  prixMat: listcour[index]
                                                      ["montant"],
                                                ),
                                              ))
                                          : downloadvideo(url, namecours);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
            //partie forum
            listcourvide
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: forumcard(
                            listemessage,
                          ),
                        ),

                        Positioned(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              var etat = listemessage[0]["etat"];
                              String prix = listemessage[0]["montant"];
                              // for (var x = 0; x <= listemessage.length; x++) {}
                              print('compte actif :' + etat);
                              // prixMat
                              if (etat == "1") {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      type: PageTransitionType.bottomToTop,
                                      child: Question(
                                          idtrim: widget.idtrim,
                                          idmat: widget.idmat)),
                                );
                              } else {
                                change(prix);
                                // String prix =
                                //     listcour.contains('montant').toString();
                                // Navigator.push(
                                //   context,
                                //   PageTransition(
                                //     alignment: Alignment.bottomCenter,
                                //     type: PageTransitionType.rightToLeft,
                                //     child: Paiement(
                                //       libtrim: widget.libtrim,
                                //       idtrim: widget.idtrim,
                                //       prixMat: prixMat,
                                //     ),
                                //   ),
                                // );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23),
                              ),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Question'),
                          ),
                          bottom: 20,
                          right: 20,
                        )
                        // child: ListView.builder(
                        //     // reverse: true,
                        //     itemCount: listemessage.length,
                        //     itemBuilder: (context, index) {
                        //       // String titre =
                        //       //     listemessage[index]['libelle'].toString();
                        //       // String desc =
                        //       //     listemessage[index]['description'].toString();
                        //       // print(titre);
                        //       String resolu = listemessage[index]
                        //               ['resolu']
                        //           .toString();

                        //       print('la valeur resolu est ' + resolu);
                        //       return Container(
                        //           margin: const EdgeInsets.all(15),
                        //           decoration: BoxDecoration(
                        //             border: Border.all(
                        //               color: Colors.blue,
                        //             ),
                        //           ),
                        //           child: forumcard(
                        //               listemessage[index]['libelle'],
                        //               listemessage[index]['description'],
                        //               "le principe des action reciproque donc un corp A et un corps B",
                        //               resolu == '0' ? false : true,
                        //               'assets/prof.png'));
                        //     })),
                        // Visibility(
                        //   visible: true,
                        //   child: Align(
                        //       alignment: Alignment.bottomLeft,
                        //       child: Container(
                        //         color: Colors.blue,
                        //         child: TextButton(
                        //             onPressed: null,
                        //             child: Text('Une question?')),
                        //       )
                        // child: DraggableScrollableSheet(
                        //     initialChildSize: 0.15,
                        //     maxChildSize: 0.50,
                        //     minChildSize: 0.15,
                        //     builder: (BuildContext context,
                        //         ScrollController scrolController) {
                        //       return Container(
                        //         decoration: BoxDecoration(
                        //           color: Colors.blue.shade100,
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         padding: const EdgeInsets.all(5),
                        //         child: Form(
                        //           key: key,
                        //           child: Padding(
                        //             padding: const EdgeInsets.only(
                        //               top: 20,
                        //             ),
                        //             child: SingleChildScrollView(
                        //               physics:
                        //                   const BouncingScrollPhysics(),
                        //               controller: scrolController,
                        //               child: Column(
                        //                 children: [
                        //                   input(
                        //                       title,
                        //                       const Icon(Icons.text_fields),
                        //                       'titre',
                        //                       TextInputType.text,
                        //                       'error titre'),
                        //                   const SizedBox(
                        //                     height: 15,
                        //                   ),
                        //                   input(
                        //                       desc,
                        //                       const Icon(
                        //                           Icons.text_snippet),
                        //                       'description',
                        //                       TextInputType.text,
                        //                       'error description'),
                        //                   const SizedBox(
                        //                     height: 15,
                        //                   ),
                        //                   boutton(context, 'envoyer', valid,
                        //                       200, 20),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //       //     }),
                        //       ),
                        // ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  //fonction de la card;
  Widget forumcard(List<Map<String, dynamic>> message) {
    String img = 'assets/prof.png';
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 1000),
      expandedHeaderPadding: EdgeInsets.only(bottom: 0.0),
      elevation: 2,
      children: message.map((chat) {
        bool expan = stringTobool(chat['resolu']);
        bool ispiece = piecejointe(chat['pieceJointe']);

        String question = chat['description'];
        String titre = chat["libelle"];
        String reponse = chat['reponse'] ?? "Problème non résolut";
        String imagepj = chat['pieceJointe'] ?? "pas de piece jointe";

        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: expan
                        ? const Icon(Icons.check_circle,
                            color: Colors.greenAccent)
                        : const Icon(Icons.access_time_filled,
                            color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      titre,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          body: Container(
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    question,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        letterSpacing: 0.3,
                        height: 1.3),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipOval(
                        child: CircleAvatar(child: Image.asset(img)),
                      ),
                      Visibility(
                        visible: !stringTobool(listemessage[0]['etat']),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextButton(
                              child: const Text('voir la réponse'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      type: PageTransitionType.leftToRight,
                                      child: Paiement(
                                        libtrim: widget.libtrim,
                                        idtrim: widget.idtrim,
                                        prixMat: listcour[0]["montant"],
                                      ),
                                    ));
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: stringTobool(listemessage[0]['etat']),
                    child: Text(
                      reponse,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                          letterSpacing: 0.3,
                          height: 1.3),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: stringTobool(listemessage[0]['etat']),
                    child: Visibility(
                      visible: ispiece,
                      child: Material(
                        elevation: 2,
                        child: InkWell(
                          onTap: (() {
                            Navigator.push(
                              context,
                              PageTransition(
                                alignment: Alignment.bottomCenter,
                                type: PageTransitionType.rightToLeft,
                                child: PieceJointe(
                                  imagepj: imagepj,
                                ),
                                fullscreenDialog: true,
                              ),
                            );
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue)),
                            height: 50,
                            child: Image.network(
                              imagepj,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isExpanded: chat["flex"],
        );
      }).toList(),
      expansionCallback: (int item, bool status) {
        // if (stringTobool(message[item]['resolu'])) {
        setState(() {
          message[item]['flex'] = !status;
        });
        // }
      },
    );
  }
}

// class Tab1 extends StatefulWidget {
//   final Widget corps;

//   const Tab1({Key? key, required this.corps}) : super(key: key);

//   @override
//   State<Tab1> createState() => _Tab1State();
// }

// class _Tab1State extends State<Tab1> {
//   TextEditingController desc = TextEditingController();
//   TextEditingController title = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.corps,
//       floatingActionButton: FloatingActionButton.extended(
//           onPressed: () {
//             showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text("Classe choisi"),
//                     titlePadding: const EdgeInsets.all(10),
//                     content: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.all(5),
//                       child: const Padding(
//                         padding: EdgeInsets.only(
//                           top: 20,
//                         ),
//                         child: SingleChildScrollView(
//                           physics: BouncingScrollPhysics(),
//                           child: Text('test')
//                         ),
//                       ),
//                     ),
//                   );
//                 });
//           },
//           icon: const Icon(Icons.add),
//           label: const Text('question')),
//     );
//   }
// }
