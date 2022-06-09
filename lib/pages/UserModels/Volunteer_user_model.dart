class VolunteerUserModel {
  String? uid;
  String? email;
  String? voluntName;
  String? collegeName;

  VolunteerUserModel({this.uid, this.email, this.voluntName, this.collegeName});

  // receiving data from server
  factory VolunteerUserModel.fromMap(map) {
    return VolunteerUserModel(
      uid: map['uid'],
      email: map['email'],
      voluntName: map['voluntName'],
      collegeName: map['collegeName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'voluntName': voluntName,
      'collegeName': collegeName,
    };
  }
}