import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:elixir2/pages/Hotel/place/auth_provider.dart';
import 'package:elixir2/pages/Login/login_home.dart';
import 'package:elixir2/pages/Hotel/Orders/product_model.dart';
import 'package:elixir2/pages/payment/payment.dart';
import 'package:elixir2/pages/volunteer/pages/Notification_screen.dart';
import 'package:elixir2/pages/volunteer/pages/Voluneditprofile_screen.dart';
import 'package:elixir2/pages/volunteer/pages/volunt_product_Detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elixir2/pages/Hotel/Orders/product_model.dart';


class VolunteerHomeScreen extends StatefulWidget {
  const  VolunteerHomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State< VolunteerHomeScreen> {
  Position _currentPosition = Position(latitude: 0.0, longitude: 0.0);
  late String _currentAddress = "";
  late String _currentAddress1 = "";

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getCurrentLocation() {
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
        _currentAddress1 = "${place.name}, ${place.locality},${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      _currentAddress = "No location found";
    }
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
    _getProductFirst();
    _getCurrentLocation();
    print("Init: $userId");
  }

  String name = "";
  String email = "";
  String image = "";
  String location = "";
  String profileUrl = "";
  String userId = "";

  static Stream<QuerySnapshot> _getProduct() {
    final _mainCollection = FirebaseFirestore.instance.collection('PRODUCTS').where("isAvailable", isEqualTo: "True");

    return _mainCollection.snapshots();
  }

  static Future<QuerySnapshot> _getProductFirst() {
    final _mainCollection = FirebaseFirestore.instance.collection('PRODUCTS').orderBy("productId", descending: true).get();

    return _mainCollection;
  }

  Future<void> _getDetails() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;
    String userdoc = user!.uid;

    FirebaseFirestore.instance.collection("Volunt_Users").doc(userdoc).snapshots().listen((event) {
      setState(() {
        userId = event.id;
        name = event.get("name").toString();

        email = event.get("email").toString();
        image = event.get("profileUrl").toString();
        location = event.get("country").toString();

        print("UserId: $userId");
      });
    });
  }

  Future<void> _delete(productId) async {
    final CollectionReference _mainCollection = FirebaseFirestore.instance.collection('PRODUCTS');
    DocumentReference documentReferencer = _mainCollection.doc(productId);

    await documentReferencer.delete().whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Package is deleted.')))).catchError((e) => print(e));
  }



  CollectionReference _collectionReference = FirebaseFirestore.instance.collection("PRODUCTS");
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color blue = const Color.fromRGBO(7, 170, 186, 0.8549019607843137);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            actions: [
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(right: width * 0.04),
                  child: Icon(
                    Icons.notification_important,
                    color: Colors.white,
                    size: width * 0.08,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen()));
                },
              )
            ],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Location", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.04, color: Colors.white)),
                  ],
                ),
                Text(_currentAddress, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.04, color: Colors.white)),
              ],
            ),
          ),
          drawer: CustomDrawer(name: name, email: email, image: image),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                children: [
                  SizedBox(height: width * 0.04),
                  Container(
                    width: width,
                    child: FutureBuilder(
                        future: _getProductFirst(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.size > 0) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  String docId = snapshot.data!.docs[index].id;
                                  String itemName = snapshot.data!.docs[index]['itemName'];
                                  String userId1 = snapshot.data!.docs[index]['userId'];
                                  String categories = snapshot.data!.docs[index]['categories'];
                                  String desc = snapshot.data!.docs[index]['description'];
                                  String mobileNumber = snapshot.data!.docs[index]['mobileNumber'];
                                  String disAppearTime = snapshot.data!.docs[index]['disAppearTime'];
                                  String address = snapshot.data!.docs[index]['address'];
                                  String donerName = snapshot.data!.docs[index]['name'];
                                  String landmark = snapshot.data!.docs[index]['landmark'];
                                  String productUrl = snapshot.data!.docs[index]['productUrl'];
                                  double productLatitude = snapshot.data!.docs[index]['latitude'];
                                  double productLongitude = snapshot.data!.docs[index]['longitude'];
                                  DateTime dateTime = DateTime.parse(disAppearTime);
                                  return Container(
                                    height: height * 0.45,
                                    width: width * 0.1,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(productUrl),
                                                      fit: BoxFit.cover,
                                                      isAntiAlias: true,
                                                    )),
                                                child: null)),
                                        Expanded(
                                          // flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: width * 0.01),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  itemName,
                                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.045, color: Colors.black),
                                                ),
                                                Text(
                                                  "Donate by $donerName",
                                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.04, color: Colors.grey),
                                                ),
                                                SizedBox(height: width * 0.02),
                                                Container(
                                                  height: 60,
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          address,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: width * 0.035,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: width * 0.2),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Time Remaining",
                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black),
                                                          ),
                                                          CountDownText(
                                                            due: dateTime,
                                                            finishedText: "Expired",
                                                            showLabel: false,
                                                            longDateName: true,
                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(blue)),
                                                          onPressed: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => VoProductDetailsScreen(
                                                                  latitude: productLatitude,
                                                                  longitude: productLongitude,
                                                                  myFood: userId == userId1 ? true : false,
                                                                  donatedUserName: name,
                                                                  userId: userId1,
                                                                  donatedUserCountry: location,
                                                                  donatedUserEmail: email,
                                                                  categories: categories,
                                                                  decription: desc,
                                                                  mobileNumber: mobileNumber,
                                                                  productId: docId,
                                                                  address: address,
                                                                  landmark: landmark,
                                                                  donerName: donerName,
                                                                  productImage: productUrl,
                                                                  productName: itemName,
                                                                  time: disAppearTime,
                                                                  dateTime: dateTime,
                                                                )));
                                                          },
                                                          child: Text("See More", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.white))),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                          return Container();
                        }),
                  ),
                  SizedBox(height: width * 0.04),
                  /*  Container(
                    width: width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: _getProduct().asBroadcastStream(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.docs.where((QueryDocumentSnapshot element) => element['itemName'].toString().toLowerCase().contains(_searchController.text.toLowerCase())).isEmpty) {
                            return Container(width: double.infinity, padding: EdgeInsets.only(top: 16), child: Center(child: Text('No product found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
                          } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.size > 0) {
                            return GridView(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 3 / 3.5, crossAxisCount: 2),
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                ...snapshot.data!.docs.where((QueryDocumentSnapshot element) => element['itemName'].toString().toLowerCase().contains(_searchController.text.toLowerCase())).map((QueryDocumentSnapshot data) {
                                  final String itemName = data.get("itemName");
                                  String docId = data.get("productId");
                                  String userId1 = data.get("userId");
                                  String categories = data.get("categories");
                                  String desc = data.get("description");
                                  String mobileNumber = data.get("mobileNumber");
                                  String disAppearTime = data.get("disAppearTime");
                                  String address = data.get("address");
                                  String donerName = data.get("name");
                                  String landmark = data.get("landmark");
                                  String productUrl = data.get("productUrl");
                                  double productLatitude = data.get('latitude');
                                  double productLongitude = data.get('longitude');
                                  DateTime dateTime = DateTime.parse(disAppearTime);

                                  return GestureDetector(
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ProductDetailsScreen(
                                          latitude: productLatitude,
                                          longitude: productLongitude,
                                          myFood: userId == userId1 ? true : false,
                                          donatedUserName: name,
                                          userId: userId1,
                                          donatedUserCountry: location,
                                          donatedUserEmail: email,
                                          categories: categories,
                                          decription: desc,
                                          mobileNumber: mobileNumber,
                                          productId: docId,
                                          address: address,
                                          landmark: landmark,
                                          donerName: donerName,
                                          productImage: productUrl,
                                          productName: itemName,
                                          time: disAppearTime,
                                          dateTime: dateTime,
                                        ))),
                                    child: Container(
                                      height: width * 0.65,
                                      width: width,
                                      margin: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: width * 0.01),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(productUrl),
                                                      fit: BoxFit.cover,
                                                      isAntiAlias: true,
                                                    )),
                                                child: null,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: width * 0.01),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            itemName,
                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.042, color: Colors.black),
                                                          ),
                                                        ),
                                                        SizedBox(width: width * 0.02),
                                                        Expanded(
                                                          child: userId == userId1
                                                              ? Container(
                                                              height: width * 0.05,
                                                              width: width * 0.1,
                                                              decoration: BoxDecoration(color: Color.fromRGBO(
                                                                  7, 170, 186,
                                                                  0.8549019607843137), borderRadius: BorderRadius.circular(10)),
                                                              child: Center(
                                                                child: Text(
                                                                  "Mine",
                                                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: width * 0.028),
                                                                ),
                                                              ))
                                                              : SizedBox(width: 0.0),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        categories,
                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.03, color: Colors.grey),
                                                      ),
                                                    ),
                                                    // SizedBox(height: width * 0.02),
                                                    // Expanded(
                                                    //   flex: 2,
                                                    //   child: Row(
                                                    //     crossAxisAlignment: CrossAxisAlignment
                                                    //         .start,
                                                    //     children: [
                                                    //       /*Expanded(
                                                    //     child: Text(
                                                    //       address,
                                                    //       maxLines: 2,
                                                    //       style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.03, color: Colors.black),
                                                    //     ),
                                                    //   ),
                                                    //   SizedBox(width: width * 0.03),*/
                                                    //       // Column(
                                                    //       //   crossAxisAlignment: CrossAxisAlignment
                                                    //       //       .start,
                                                    //       //   mainAxisAlignment: MainAxisAlignment
                                                    //       //       .start,
                                                    //       //   children: [
                                                    //       //     Text(
                                                    //       //       "Remaining Time:",
                                                    //       //       style: GoogleFonts
                                                    //       //           .poppins(
                                                    //       //           fontWeight: FontWeight
                                                    //       //               .w400,
                                                    //       //           fontSize: width *
                                                    //       //               0.032,
                                                    //       //           color: Colors
                                                    //       //               .black),
                                                    //       //     ),
                                                    //       //     CountDownText(
                                                    //       //       due: dateTime,
                                                    //       //       finishedText: "Expired",
                                                    //       //       showLabel: false,
                                                    //       //       longDateName: true,
                                                    //       //       style: GoogleFonts
                                                    //       //           .poppins(
                                                    //       //           fontWeight: FontWeight
                                                    //       //               .w400,
                                                    //       //           fontSize: width *
                                                    //       //               0.03,
                                                    //       //           color: Colors
                                                    //       //               .black),
                                                    //       //     ),
                                                    //       //   ],
                                                    //       // ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                              ],
                            );
                          }
                          /*else if (snapshot.data != null && snapshot.data!.size == 0) {
                            return Padding(padding: EdgeInsets.only(top: height / 6), child: Center(child: Text('No product available', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
                          }*/
                          return const Center(child: CircularProgressIndicator(color: Colors.black));
                        }),
                  ),
                  SizedBox(height: width * 0.1),*/
                ],
              ),
            ),
          )),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required this.name,
    required this.email,
    required this.image,
  }) : super(key: key);

  final String name;
  final String email;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200,
            padding: EdgeInsets.only(top: 70, right: 16, left: 16, bottom: 8),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(7, 170, 186, 0.8549019607843137),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                            child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image))), child: null)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: 'Hi, $name',
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
                                    children: [
                                      TextSpan(
                                        text: '\n$email',
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VolunEditProfileScreen()));
                  },
                  child: Text(
                    "EDIT PROFILE",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16)
              ],
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.contacts, size: 14),
                      ),
                      TextSpan(text: " Your Acceptance", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VolunteerHomeScreen()));
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.money, size: 14),
                      ),
                      TextSpan(text: "Payment", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Payment()));
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.credit_card, size: 14),
                      ),
                      TextSpan(text: "Statistics", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            onTap: () async {
              const url = "https://app.powerbi.com/groups/me/dashboards/76b24da0-ae4d-49c2-8569-25c3d62885e1?ctid=6b8b8296-bdff-4ad8-93ad-84bcbf3842f5&pbi_source=linkShare";

              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Error Occurred in lauching the website';
              }
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.help, size: 14)),
                      TextSpan(text: "Help", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerHomeScreen()));
            },
          ),
          Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 30, left: 16),

          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  AuthClass().logOut();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginHome()), (route) => false);
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(203, 28, 122, 1.0),
                  ),
                  primary: Colors.white,
                  onPrimary: const Color.fromRGBO(203, 28, 122, 1.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// GridView.builder(
//     physics: PageScrollPhysics(
//         parent: NeverScrollableScrollPhysics()),
//     scrollDirection: Axis.vertical,
//     shrinkWrap: true,
//     semanticChildCount: 2,
//     itemCount: snapshot.data!.docs.length,
//     gridDelegate:
//         const SliverGridDelegateWithFixedCrossAxisCount(
//             childAspectRatio: 3 / 4,
//             crossAxisCount: 2),
//     itemBuilder: (context, index) {
//       String docId = snapshot.data!.docs[index].id;

//       String itemName =
//           snapshot.data!.docs[index]['itemName'];
//       String userId1 =
//           snapshot.data!.docs[index]['userId'];
//       String categories =
//           snapshot.data!.docs[index]['categories'];
//       String desc =
//           snapshot.data!.docs[index]['description'];
//       String mobileNumber = snapshot
//           .data!.docs[index]['mobileNumber'];
//       String disAppearTime = snapshot
//           .data!.docs[index]['disAppearTime'];
//       String address =
//           snapshot.data!.docs[index]['address'];
//       String donerName =
//           snapshot.data!.docs[index]['name'];
//       String landmark =
//           snapshot.data!.docs[index]['landmark'];
//       String productUrl =
//           snapshot.data!.docs[index]['productUrl'];
//       DateTime dateTime =
//           DateTime.parse(disAppearTime);

//       return
// GestureDetector(
//         onTap: () => Navigator.of(context).push(
//             MaterialPageRoute(
//                 builder: (context) =>
//                     ProductDetailsScreen(
//                       latitude:
//                           _currentPosition.latitude,
//                       longitude: _currentPosition
//                           .longitude,
//                       myFood: userId == userId1
//                           ? true
//                           : false,
//                       donatedUserName: name,
//                       userId: userId1,
//                       categories: categories,
//                       decription: desc,
//                       mobileNumber: mobileNumber,
//                       productId: docId,
//                       address: address,
//                       landmark: landmark,
//                       donerName: donerName,
//                       productImage: productUrl,
//                       productName: itemName,
//                       time: disAppearTime,
//                       dateTime: dateTime,
//                     ))),
//         child: Container(
//           height: width * 0.65,
//           width: width,
//           margin: EdgeInsets.symmetric(
//               horizontal: width * 0.01,
//               vertical: width * 0.01),
//           decoration: BoxDecoration(
//               borderRadius:
//                   BorderRadius.circular(10),
//               border:
//                   Border.all(color: Colors.grey)),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                   child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft:
//                             Radius.circular(10),
//                         topRight:
//                             Radius.circular(10)),
//                     image: DecorationImage(
//                       image:
//                           NetworkImage(productUrl),
//                       fit: BoxFit.cover,
//                       isAntiAlias: true,
//                     )),
//                 child: null,
//               )),
//               Expanded(
//                   child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.02,
//                     vertical: width * 0.01),
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.stretch,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             itemName,
//                             style:
//                                 GoogleFonts.poppins(
//                                     fontWeight:
//                                         FontWeight
//                                             .w400,
//                                     fontSize:
//                                         width *
//                                             0.042,
//                                     color: Colors
//                                         .black),
//                           ),
//                         ),
//                         SizedBox(
//                             width: width * 0.02),
//                         Expanded(
//                           child: userId == userId1
//                               ? Container(
//                                   height:
//                                       width * 0.05,
//                                   width:
//                                       width * 0.1,
//                                   decoration: BoxDecoration(
//                                       color: Color
//                                           .fromRGBO(
//                                               5,
//                                               25,
//                                               55,
//                                               1),
//                                       borderRadius:
//                                           BorderRadius
//                                               .circular(
//                                                   10)),
//                                   child: Center(
//                                     child: Text(
//                                       "Mine",
//                                       style: GoogleFonts.poppins(
//                                           color: Colors
//                                               .white,
//                                           fontSize:
//                                               width *
//                                                   0.028),
//                                     ),
//                                   ))
//                               : SizedBox(
//                                   width: 0.0),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: Text(
//                         categories,
//                         style: GoogleFonts.poppins(
//                             fontWeight:
//                                 FontWeight.w400,
//                             fontSize: width * 0.03,
//                             color: Colors.grey),
//                       ),
//                     ),
//                     // SizedBox(height: width * 0.02),
//                     Expanded(
//                       flex: 2,
//                       child: Row(
//                         crossAxisAlignment:
//                             CrossAxisAlignment
//                                 .start,
//                         children: [
//                           Text(
//                             "4.3 KM",
//                             style:
//                                 GoogleFonts.poppins(
//                                     fontWeight:
//                                         FontWeight
//                                             .w400,
//                                     fontSize:
//                                         width *
//                                             0.03,
//                                     color: Colors
//                                         .black),
//                           ),
//                           SizedBox(
//                               width: width * 0.03),
//                           Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment
//                                     .start,
//                             mainAxisAlignment:
//                                 MainAxisAlignment
//                                     .start,
//                             children: [
//                               Text(
//                                 "Pickup Time:",
//                                 style: GoogleFonts.poppins(
//                                     fontWeight:
//                                         FontWeight
//                                             .w400,
//                                     fontSize:
//                                         width *
//                                             0.032,
//                                     color: Colors
//                                         .black),
//                               ),
//                               CountDownText(
//                                 due: dateTime,
//                                 finishedText:
//                                     "Expired",
//                                 showLabel: false,
//                                 longDateName: true,
//                                 style: GoogleFonts
//                                     .poppins(
//                                         fontWeight:
//                                             FontWeight
//                                                 .w400,
//                                         fontSize:
//                                             width *
//                                                 0.03,
//                                         color: Colors
//                                             .black),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//             ],
//           ),
//         ),
//       );
//     });