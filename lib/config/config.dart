import 'dart:convert';

import 'package:flutter/services.dart';

class Configuration{
  //static
  static Future<Map<String, dynamic>> getConfig(){
    return rootBundle.loadString('assets/config/config.json').then(
      (value) {
        //json => MAp<String. danamic>
        return jsonDecode(value) as Map<String, dynamic>;
      },
       ).catchError((err) {}); //วิ่งไปที่ไฟล์ต่างๆได้
  }
}