// To parse this JSON data, do
//
//     final customerResgisterPostResponse = customerResgisterPostResponseFromJson(jsonString);

import 'dart:convert';

CustomerResgisterPostResponse customerResgisterPostResponseFromJson(String str) => CustomerResgisterPostResponse.fromJson(json.decode(str));

String customerResgisterPostResponseToJson(CustomerResgisterPostResponse data) => json.encode(data.toJson());

class CustomerResgisterPostResponse {
    String message;
    int id;

    CustomerResgisterPostResponse({
        required this.message,
        required this.id,
    });

    factory CustomerResgisterPostResponse.fromJson(Map<String, dynamic> json) => CustomerResgisterPostResponse(
        message: json["message"],
        id: json["id"],
    );

  get customer => null;

    Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
    };
}
