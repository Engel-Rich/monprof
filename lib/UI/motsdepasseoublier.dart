import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

final formkey = GlobalKey<FormState>();
final phoneController = TextEditingController();

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reinitialisé'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const Text(
                'Vous allez recevoir un sms de reinitilisation '
                'de votre mots de passe, svp vérifier votre messagerie '
                'telephonique apres validation',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty || val.length < 9) {
                    return 'entre un numero de téléphone valide';
                  } else {
                    return null;
                  }
                },
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      //borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                    label: const Text('numero de téléphone'),
                    fillColor: Colors.grey.withOpacity(0.3),
                    focusColor: Colors.transparent,
                    filled: true),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    return;
                  } else {
                    return;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: const Center(
                      child: Text("Reinitialisé",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
