

String? drivingResponse;

class DrivingResponse {

  List<Route>? routes;
  List<Waypoint>? waypoints;
  String? code;
  String? uuid;

  DrivingResponse({
    this.routes,
    this.waypoints,
    this.code,
    this.uuid,
  });



  factory DrivingResponse.fromMap(Map<String, dynamic> map) => DrivingResponse(
    routes: List<Route>.from(map["routes"].map((x) => Route.fromMap(x))),
    waypoints: List<Waypoint>.from(map["waypoints"].map((x) => Waypoint.frommap(x))),
    code: map["code"],
    uuid: map["uuid"],
  );

  Map<String, dynamic> tomMap() => {
    "routes": List<dynamic>.from(routes!.map((x) => x.tomap())),
    "waypoints": List<dynamic>.from(waypoints!.map((x) => x.tomap())),
    "code": code,
    "uuid": uuid,
  };
}

class Route {


  String? weightName;
  double? weight;
  double? duration;
  double? distance;
  List<Leg>? legs;
  String? geometry;

  Route({
    this.weightName,
    this.weight,
    this.duration,
    this.distance,
    this.legs,
    this.geometry,
  });

  factory Route.fromMap(Map<String, dynamic> map) => Route(
    weightName: map["weight_name"],
    weight: map["weight"].toDouble(),
    duration: map["duration"].toDouble(),
    distance: map["distance"].toDouble(),
    legs: List<Leg>.from(map["legs"].map((x) => Leg.frommap(x))),
    geometry: map["geometry"],
  );

  Map<String, dynamic> tomap() => {
    "weight_name": weightName,
    "weight": weight,
    "duration": duration,
    "distance": distance,
    "legs": List<dynamic>.from(legs!.map((x) => x.tomap())),
    "geometry": geometry,
  };
}

class Leg {

  List<dynamic>? viaWaypoints;
  List<Admin>? admins;
  double? weight;
  double? duration;
  List<dynamic>? steps;
  double? distance;
  String? summary;

  Leg({
    this.viaWaypoints,
    this.admins,
    this.weight,
    this.duration,
    this.steps,
    this.distance,
    this.summary,
  });



  factory Leg.frommap(Map<String, dynamic> map) => Leg(
    viaWaypoints: List<dynamic>.from(map["via_waypoints"].map((x) => x)),
    admins: List<Admin>.from(map["admins"].map((x) => Admin.frommap(x))),
    weight: map["weight"].toDouble(),
    duration: map["duration"].toDouble(),
    steps: List<dynamic>.from(map["steps"].map((x) => x)),
    distance: map["distance"].toDouble(),
    summary: map["summary"],
  );

  Map<String, dynamic> tomap() => {
    "via_waypoints": List<dynamic>.from(viaWaypoints!.map((x) => x)),
    "admins": List<dynamic>.from(admins!.map((x) => x.tomap())),
    "weight": weight,
    "duration": duration,
    "steps": List<dynamic>.from(steps!.map((x) => x)),
    "distance": distance,
    "summary": summary,
  };
}

class Admin {

  String? iso31661Alpha3;
  String? iso31661;

  Admin({
    this.iso31661Alpha3,
    this.iso31661,
  });



  factory Admin.frommap(Map<String, dynamic> map) => Admin(
    iso31661Alpha3: map["iso_3166_1_alpha3"],
    iso31661: map["iso_3166_1"],
  );

  Map<String, dynamic> tomap() => {
    "iso_3166_1_alpha3": iso31661Alpha3,
    "iso_3166_1": iso31661,
  };
}

class Waypoint {

  double? distance;
  String? name;
  List<double>? location;

  Waypoint({
    this.distance,
    this.name,
    this.location,
  });



  factory Waypoint.frommap(Map<String, dynamic> map) => Waypoint(
    distance: map["distance"].toDouble(),
    name: map["name"],
    location: List<double>.from(map["location"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> tomap() => {
    "distance": distance,
    "name": name,
    "location": List<dynamic>.from(location!.map((x) => x)),
  };
}