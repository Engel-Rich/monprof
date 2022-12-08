import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:monprof/UI/home.dart';
import 'package:monprof/UI/homeParent.dart';
// import 'package:monprof/UI/login.dart';

import 'package:monprof/UI/onboardinding.dart';
import 'package:monprof/back-end/modelparent.dart';

// import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class TransitionPage extends StatefulWidget {
  const TransitionPage({Key? key}) : super(key: key);

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  bool login = false;
  bool logp = false;
  Future<void> isconnected() async {
    await Eleve.getEleve();
    await Parent.getParent();
    if (Parent.sessionParent.idParent!.trim().isEmpty ||
        Parent.sessionParent.profession!.trim().isEmpty) {
      setState(() {
        logp = false;
      });
    } else {
      setState(() {
        logp = true;
      });
    }
    if (Eleve.sessionEleve == null || Eleve.idClasse == '') {
      setState(() {
        login = false;
      });
      debugPrint(
          'L\'Id de la classe dans la session récupére est : ${Eleve.idClasse}');
      Eleve.sessionEleve.printinfo();
    } else if (Eleve.sessionEleve.classe == "" ||
        Eleve.sessionEleve.telephone == null ||
        Eleve.sessionEleve.idc == null) {
      setState(() {
        login = false;
        Eleve.sessionEleve.printinfo();
      });
    } else {
      setState(() {
        login = true;
      });
    }
  }

  void logout() async {
    await SharedPreferences.getInstance().then((value) {
      value.remove("eleve");
    });

    setState(() {
      login = false;
      logp = false;
    });
    // Navigator.push(
    //   context,
    //   PageTransition(
    //       child: const Login(), type: PageTransitionType.leftToRight),
    // );
  }

  DateTime presbackButton = DateTime.now();
  @override
  void initState() {
    logout();
    isconnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(presbackButton);
        if (login || logp) {
          if (difference > const Duration(seconds: 2)) {
            Fluttertoast.showToast(
                msg: "appuiez deux fois pour quitter",
                toastLength: Toast.LENGTH_SHORT);
          } else {
            SystemNavigator.pop();
            Fluttertoast.cancel();
          }
          presbackButton = DateTime.now();
          return false;
        } else {
          presbackButton = DateTime.now();
          return false;
        }
      },
      child: logp
          ? const HomeParent()
          : login
              ? Home(
                  logou: logout,
                  eleve: Eleve.sessionEleve,
                )
              : const Onboarding(),
    );
  }
}
