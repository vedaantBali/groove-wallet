import 'dart:convert';
import 'package:http/http.dart' as http;

class WalletController {
  var publicKey, balance;

  Future<void> getWalletInfo(userUrl) async {
    String url = 'https://$userUrl.herokuapp.com/api/wallet-info';
    var response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);

    publicKey = responseData['address'];
    balance = responseData['balance'];
  }
}
