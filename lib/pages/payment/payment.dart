import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  Donate createState() => Donate();
}

class Donate extends State<Payment> {

  late final Razorpay razor;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    razor = Razorpay();

    razor.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razor.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razor.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razor.clear();
  }

  void openCheckout(){
    var options = {
      "key" : "rzp_test_DqKG8iMxUxjq7I",
      "amount" : num.parse(textEditingController.text)*100,
      "name" : "Elixir",
      "description" : "Donation amount",
      "prefill" : {
        "contact" : "9176366054",
        "email" : "foodiedesu@gmail.com"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razor.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(){
    print("Payment success");
    Toast.show("Payment success", context);
  }

  void handlerErrorFailure(){
    print("Payment error");
    Toast.show("Payment error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade700,
      ),
      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage("assets/Background.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              )
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/ELIXIR_logo.png'),
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                color: Colors.transparent,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    children: [
                      const Text ("Donate", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,color: Colors.white,
                      ),),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30
                        ),
                        child: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                  hintText: "Amount you wish to Donate"
                              ),
                            ),
                            const SizedBox(height: 12,),
                               ElevatedButton(
                                child: const Text("Donate Now", style: TextStyle(
                                    color: Colors.white
                                ),),
                                onPressed: (){
                                  openCheckout();
                                },
                              ),
                            ],),
                        ),
                    ]
                )


              ],
            ),
          ],
        ),
      ),);
  }

  /*Future<void> debugFillProperties(DiagnosticPropertiesBuilder properties) async {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Razorpay>('razor', razor));
  }*/
}