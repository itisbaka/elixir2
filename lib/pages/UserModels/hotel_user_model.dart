class HotelUserModel {
  String? uid;
  String? email;
  String? hotelName;
  //String? secondName;

  HotelUserModel({this.uid, this.email, this.hotelName});

  // receiving data from server
  factory HotelUserModel.fromMap(map) {
    return HotelUserModel(
      uid: map['uid'],
      email: map['email'],
      hotelName: map['hotelName'],
      //secondName: map['secondName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'hotelName': hotelName,
      //'secondName': secondName,
    };
  }
}