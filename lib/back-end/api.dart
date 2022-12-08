import 'package:http/http.dart' as http;

String domain = '38.242.146.73';
int port = 951;

class Api {
  //Inscription
  void inscription(
    String email,
    String nom,
    String password,
    String telephone,
  ) async {
    final result = await http.post(Uri.parse(
        'http://$domain:$port/monprof/web/consultation/eleveService.php?requete_type=1&nom=${nom}&email=${email}&telephone=${telephone}&password=${password}'));
    print(result);
    print(result.body);
    //List<UserModel> model = userModelFromJson(result.body);
  }

  void userdata(String id) async {
    final res = await http.get(Uri.parse(
        'http://$domain:$port/monprof/web/consultation/eleveService.php?requete_type=2&id=${id}'));
    print(res.body);
  }

  void recuperecours() {}
}
