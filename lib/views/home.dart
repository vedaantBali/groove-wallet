import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clipboard/clipboard.dart';
import 'package:groove_wallet/controllers/transact_controller.dart';
import 'package:groove_wallet/controllers/wallet_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController urlController = new TextEditingController();
  TextEditingController receiverController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  WalletController walletController = new WalletController();
  var walletKey, walletBalance;
  var _isLoading = false;

  getWallet() async {
    await walletController.getWalletInfo(urlController.text);
    setState(() {
      walletKey = walletController.publicKey;
      walletBalance = walletController.balance;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groove Wallet'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.exit_to_app_outlined),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Groove-Chain Client.',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter your wallet url',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                Container(
                  width: 150,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'your url'
                    ),
                    controller: urlController,
                    autocorrect: false,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Text(
                  '.herokuapp.com',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        getWallet();
                      },
                      child: Text('Get Wallet Info')
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: _isLoading ? Center(child: CircularProgressIndicator()) :
                Column (
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Wallet', style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor
                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Public Key: $walletKey'.length > 40 ?
                                'Public Key: $walletKey'.substring(0, 40) :
                                'Public Key: 0',
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              ),
                              Text('...', style: TextStyle(fontSize: 16),)
                            ],
                          ),
                          Container(
                            child: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: walletKey));
                              },
                              icon: Icon(Icons.copy_outlined),
                              iconSize: 16,
                              tooltip: 'copy public key',
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      Text(''),
                      Row(
                        children: [
                          Text('Balance: $walletBalance', style: TextStyle(
                              fontSize: 16
                          ),)
                        ],
                      ),
                    ]
                ),

              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Send Groove-Coins', style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor
                        ),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Receiver: ', style: TextStyle(fontSize: 16),),
                        Text('  '),
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: TextFormField(
                            controller: receiverController,
                            autocorrect: false,
                            decoration: InputDecoration(
                                hintText: 'receiver'
                            ),
                          ),
                        ),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              FlutterClipboard.paste().then((value) {
                                setState(() {
                                  receiverController.text = value;
                                });
                              });
                            },
                            icon: Icon(Icons.paste_outlined),
                            iconSize: 16,
                            tooltip: 'paste public key',
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Amount: ', style: TextStyle(fontSize: 16),),
                        Text('  '),
                        Container(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: amountController,
                            autocorrect: false,
                            decoration: InputDecoration(
                                hintText: 'amount'
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(''),
                    Container(
                        child: ElevatedButton(
                          child: Text('Send Groove-Coins'),
                          onPressed: () {
                            TransactController.transact(
                                receiver: receiverController.text,
                                amount: amountController.text,
                                user: urlController.text
                            );
                          },
                        )
                    ),
                  ],
                ),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
