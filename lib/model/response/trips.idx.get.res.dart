// To parse this JSON data, do
//
//     final tripsIdxGetRsesponse = tripsIdxGetRsesponseFromJson(jsonString);

import 'dart:convert';

TripsIdxGetRsesponse tripsIdxGetRsesponseFromJson(String str) => TripsIdxGetRsesponse.fromJson(json.decode(str));

String tripsIdxGetRsesponseToJson(TripsIdxGetRsesponse data) => json.encode(data.toJson());

class TripsIdxGetRsesponse {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    TripsIdxGetRsesponse({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory TripsIdxGetRsesponse.fromJson(Map<String, dynamic> json) => TripsIdxGetRsesponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
    };
}
