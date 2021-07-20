import 'package:http/http.dart' as http;

class TransactController {

  static transact({ required receiver, required amount, required user }) {

    var jsonString = '{\"receiver\": \"$receiver\",\"amount\":$amount}';
    String url = 'https://$user.herokuapp.com/api/transact';
    print(jsonString);
    http.post(Uri.parse(url), body: jsonString, headers: {
      "Content-Type" : "application/json"
    }).then((result) {
      print(result.body);
    });
  }
}