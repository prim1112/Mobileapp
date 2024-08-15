// To parse this JSON data, do
//
//     final customerResgisterPostRequest = customerResgisterPostRequestFromJson(jsonString);

import 'dart:convert';

CustomerResgisterPostRequest customerResgisterPostRequestFromJson(String str) => CustomerResgisterPostRequest.fromJson(json.decode(str));

String customerResgisterPostRequestToJson(CustomerResgisterPostRequest data) => json.encode(data.toJson());

class CustomerResgisterPostRequest {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomerResgisterPostRequest({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomerResgisterPostRequest.fromJson(Map<String, dynamic> json) => CustomerResgisterPostRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
